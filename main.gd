extends Node2D
@export var unitScene: PackedScene
@export var enemySpawnSpeed = 0.25
@export var spawn_throw_force = Vector2(100, 400)
@export var spawn_throw_variance_y = 300
@export var spawn_throw_variance_x = 50
@onready var game_variables = get_node("/root/GameVariables")
@onready var word_list = get_node("/root/WordList")
const unitEmitter = preload("res://classes/Unit/unit.tscn")

func _generateRandomPluck2DVector():
	var xForce = spawn_throw_force.x + randi() % spawn_throw_variance_x
	var yVariance = randi() % spawn_throw_variance_y
	var yForce = spawn_throw_force.y + yVariance
	return Vector2(xForce, yForce)

func _ready():
	$EnemyFarmerPickTimer.set_wait_time(enemySpawnSpeed)
	$EnemyFarmerPickTimer.start()
	randomize() # set random seed

func _on_debug_ui_debug_spawn_enemy_unit():
	print("debug: spawn enemy unit")
	spawn_unit(UnitOwnerEnum.VALUES.ENEMY, UnitTypeEnum.VALUES.ROCK)


func _on_debug_ui_debug_spawn_player_unit():
	print("debug: spawn player unit")
	spawn_unit(UnitOwnerEnum.VALUES.PLAYER, UnitTypeEnum.VALUES.ROCK)

func _input(event: InputEvent):
	if event.is_action_pressed("rock") || event.is_action_pressed("paper") || event.is_action_pressed("scissors"):
		$Farmer.pick_item()
		var eventAsEnum
		if event.is_action_pressed("rock"):
			eventAsEnum = UnitTypeEnum.VALUES.ROCK
		elif event.is_action_pressed("paper"):
			eventAsEnum = UnitTypeEnum.VALUES.PAPER
		elif event.is_action_pressed("scissors"):
			eventAsEnum = UnitTypeEnum.VALUES.SCISSORS
		else:
			print("Error occured, unrecognized input for unit spawn")
			eventAsEnum = UnitTypeEnum.VALUES.ROCK
		spawn_unit(UnitOwnerEnum.VALUES.PLAYER, eventAsEnum)

#func spawn_unit_OLD(unitOwner):
#	var spawnedUnit = carrotmanScene.instantiate()
#	var startPosition
#	if unitOwner == PLAYER:
#		startPosition = $PlayerUnitSpawnPosition.position
#	else:
#		startPosition = $EnemyUnitSpawnPosition.position
#
#	var pluckForceVector = _generateRandomPluck2DVector()
#	var pluckSFXPitchScale = ((pluckForceVector.y - spawn_throw_force.y) / spawn_throw_variance_y * .25) + .75
#	spawnedUnit.setPluckState(unitOwner, startPosition, pluckForceVector)
#	$AudioManager.pluckUp(pluckSFXPitchScale)
#	add_child(spawnedUnit)

## _on_unit_collide
## Describes to the game runner who the winner of a unit collision is.
## The unit management of the fight results is handled by the reporting nodes.
## Since the only one reporting the fight is the player's unit, we don't have to
## account for fight results from the enemy unit.
##
## fight_winner - -1 means enemy won, 0 means tie, 1 means player unit won
func _on_unit_collide(fight_winner: int):
	# Nothing happens on tie to the scores
	if fight_winner == 1:
		game_variables.inc_player_score()
	elif fight_winner == -1:
		game_variables.inc_enemy_score()

func spawn_unit(unit_owner: UnitOwnerEnum.VALUES, unit_type: UnitTypeEnum.VALUES):
	var spawned_scene = unitScene.instantiate()
	spawned_scene.unitCollide.connect(_on_unit_collide)
	
	var start_position
	if unit_owner == UnitOwnerEnum.VALUES.PLAYER: 
		start_position = $PlayerUnitSpawnPosition.position
	else:
		start_position = $EnemyUnitSpawnPosition.position

	var pluck_force = _generateRandomPluck2DVector()
	var pluckSFXPitchScale = ((pluck_force.y - spawn_throw_force.y) / spawn_throw_variance_y * .25) + .75
	spawned_scene.init(unit_owner, unit_type)
	spawned_scene.set_state(UnitStateEnum.VALUES.PLUCK, start_position)
	spawned_scene.call_state(UnitStateEnum.VALUES.PLUCK, "start_pluck", [unit_owner, pluck_force])
	$AudioManager.pluck_up(pluckSFXPitchScale)
	add_child(spawned_scene)

func _on_enemy_farmer_pick_timer_timeout():
	# Attempt to randomize to simulate player input
	var shouldSpawnEnemy = randi() % 2 # Gives random value of either 0 or 1
	if shouldSpawnEnemy == 0:
		$EnemyFarmer.pick_item()
		var unitTypeInt = randi() % UnitTypeEnum.VALUES.size()
		print(UnitTypeEnum.VALUES.keys()[unitTypeInt])
		spawn_unit(UnitOwnerEnum.VALUES.ENEMY, UnitTypeEnum.VALUES.values()[unitTypeInt])


