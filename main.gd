extends Node2D
@onready var game_variables = get_node("/root/GameVariables")
@onready var audio_manager = get_node("/root/AudioManager")
const unitEmitter = preload("res://classes/Player/Unit/unit.tscn")

#################
# Init and starting fns
#################
func _ready():
	$Player.hide()
	$Enemy.hide()
	$HealthBars.hide()
	$UI/GameOverScreen.hide()
	randomize() # set random seed


##################
# Handler fns
##################
func _start_2_player_game():
	$HealthBars.show()
	$HealthBars/PlayerHealthBar.init(UnitOwnerEnum.VALUES.PLAYER1)
	$HealthBars/EnemyHealthBar.init(UnitOwnerEnum.VALUES.PLAYER2)
	$UI/StartScreen.hide()
	$PlayerLoseArea.set_unit_owner(UnitOwnerEnum.VALUES.PLAYER1)
	$Player.init(UnitOwnerEnum.VALUES.PLAYER1, PlayerResourceLoader.SKINS.farmer)
	$Enemy.init(UnitOwnerEnum.VALUES.PLAYER2, PlayerResourceLoader.SKINS.farmer)
	$EnemyLoseArea.set_unit_owner(UnitOwnerEnum.VALUES.PLAYER2)
	

func _start_cpu_game():
	$HealthBars.show()
	$HealthBars/PlayerHealthBar.init(UnitOwnerEnum.VALUES.PLAYER1)
	$HealthBars/EnemyHealthBar.init(UnitOwnerEnum.VALUES.CPU)
	$UI/StartScreen.hide()
	$Player.init(UnitOwnerEnum.VALUES.PLAYER1, PlayerResourceLoader.SKINS.farmer)
	$PlayerLoseArea.set_unit_owner(UnitOwnerEnum.VALUES.PLAYER1)
	$Enemy.init(UnitOwnerEnum.VALUES.CPU, PlayerResourceLoader.SKINS.farmer)
	$EnemyLoseArea.set_unit_owner(UnitOwnerEnum.VALUES.CPU)
	# Set some cpu specific stuff
	$EnemyFarmerPickTimer.set_wait_time(game_variables.enemy_spawn_speed)
	$EnemyFarmerPickTimer.start()
	$EnemyDifficultyTimer.start()

func _on_debug_ui_debug_spawn_enemy_unit():
	print("debug: spawn enemy unit")
	$Enemy.spawn_unit(UnitTypeEnum.VALUES.ROCK)


func _on_debug_ui_debug_spawn_player_unit():
	print("debug: spawn player unit")
	$Player.spawn_unit(UnitTypeEnum.VALUES.ROCK)

## _on_unit_collide
## Describes to the game runner who the winner of a unit collision is.
## The unit management of the fight results is handled by the reporting nodes.
## Since the only one reporting the fight is the player's unit, we don't have to
## account for fight results from the enemy unit.
##
## fight_winner - -1 means enemy won, 0 means tie, 1 means player unit won
func _on_unit_collide(_fight_winner: int):
	game_variables.inc_player_score()
	## Old system below	
	# Nothing happens on tie to the scores
#	if fight_winner == 1:
#		game_variables.inc_player_score()
#	elif fight_winner == -1:
#		game_variables.inc_enemy_score()

func _on_enemy_farmer_pick_timer_timeout():
	# Attempt to randomize to simulate player input
	var spawn_chance = 3 # Spawn chance is spawn_chance-1/spawn_chance
	var should_spawn_enemy = randi() % spawn_chance # Gives random value of either 0-2
	if should_spawn_enemy != 0:
		var unit_type_idx = randi() % UnitTypeEnum.VALUES.size()
		$Enemy.spawn_unit(UnitTypeEnum.VALUES.values()[unit_type_idx])

func _on_player_unit_spawned(spawned_scene):
	spawned_scene.unit_collide.connect(_on_unit_collide)
	add_child(spawned_scene)

func _on_enemy_unit_spawned(spawned_scene):
	# For now let's not listen on the unit collide, enemy doesn't fire anyway
	# spawned_scene.unit_collide.connect(_on_unit_collide)
	add_child(spawned_scene)

func _on_enemy_difficulty_timer_timeout():
	var new_difficulty: float = max(game_variables.enemy_spawn_speed - 0.25, 0.25)
	$EnemyFarmerPickTimer.set_wait_time(new_difficulty)
	game_variables.set_spawn_speed(new_difficulty)

func _on_game_over_screen_quit():
	pass # Replace with function body.


func _on_game_over_screen_reset_1p():
	pass # Replace with function body.


func _on_game_over_screen_reset_2p():
	pass # Replace with function body.


func _on_player_lose_area_lose_area_entered(unit_owner: UnitOwnerEnum.VALUES):
	if unit_owner != $Player.get_unit_owner():
		$HealthBars/PlayerHealthBar.hurt()
		game_variables.set_player_health(game_variables.get_player_health() - 10)

func _on_enemy_lose_area_lose_area_entered(unit_owner: UnitOwnerEnum.VALUES):
	if unit_owner != $Enemy.get_unit_owner():
		$HealthBars/EnemyHealthBar.hurt()
		game_variables.set_enemy_health(game_variables.get_enemy_health() - 10)
