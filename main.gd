extends Node2D
@export var carrotmanScene: PackedScene
@export var enemySpawnSpeed = 0.25
const carrotManEmitter = preload("res://carrotman.tscn")

# TODO: import this instead of duplicating enum
enum {PLAYER,ENEMY}

func _ready():
	$EnemyFarmerPickTimer.set_wait_time(enemySpawnSpeed)
	$EnemyFarmerPickTimer.start()
	randomize() # set random seed

func _on_debug_ui_debug_spawn_enemy_unit():
	print("debug: spawn enemy unit")
	spawnUnit(ENEMY)


func _on_debug_ui_debug_spawn_player_unit():
	print("debug: spawn player unit")
	spawnUnit(PLAYER)

func _input(event):
	if (event.is_action_pressed("pick_item")):
		$Farmer.pick_item()
		spawnUnit(PLAYER)

func spawnUnit(unitOwner):
	var spawnedUnit = carrotmanScene.instantiate()
	var startPosition
	if unitOwner == PLAYER:
		startPosition = $PlayerUnitSpawnPosition.position
	else:
		startPosition = $EnemyUnitSpawnPosition.position
	spawnedUnit.init(unitOwner, startPosition)
	spawnedUnit.startMoving()
	add_child(spawnedUnit)


func _on_enemy_farmer_pick_timer_timeout():
	print("Enemy farmer pick timer timeout")
	# Attempt to randomize to simulate player input
	var shouldSpawnEnemy = randi() % 2 # Gives random value between 0 and 1
	print(shouldSpawnEnemy)
	if shouldSpawnEnemy == 0:
		$EnemyFarmer.pick_item()
		spawnUnit(ENEMY)
