extends Node2D
@export var unitScene: PackedScene
@export var enemySpawnSpeed = 0.25
@export var spawn_throw_force = Vector2(100, 400)
@export var spawn_throw_variance_y = 300
@export var spawn_throw_variance_x = 50

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
	spawn_unit(UnitOwnerEnum.ENEMY)


func _on_debug_ui_debug_spawn_player_unit():
	print("debug: spawn player unit")
	spawn_unit(UnitOwnerEnum.PLAYER)

func _input(event):
	if (event.is_action_pressed("pick_item")):
		$Farmer.pick_item()
		spawn_unit(UnitOwnerEnum.PLAYER)

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


func spawn_unit(unitOwner):
	var spawnedUnit = unitScene.instantiate()
	var startPosition
	if unitOwner == UnitOwnerEnum.PLAYER: 
		startPosition = $PlayerUnitSpawnPosition.position
	else:
		startPosition = $EnemyUnitSpawnPosition.position

	var pluckForceVector = _generateRandomPluck2DVector()
	var pluckSFXPitchScale = ((pluckForceVector.y - spawn_throw_force.y) / spawn_throw_variance_y * .25) + .75
	spawnedUnit.init(unitOwner)
	spawnedUnit.set_state(UnitStateEnum.PLUCK, startPosition)
	spawnedUnit.call_state(UnitStateEnum.PLUCK, "start_pluck", [unitOwner, pluckForceVector])
	$AudioManager.pluck_up(pluckSFXPitchScale)
	add_child(spawnedUnit)

func _on_enemy_farmer_pick_timer_timeout():
	# Attempt to randomize to simulate player input
	var shouldSpawnEnemy = randi() % 2 # Gives random value of either 0 or 1
	if shouldSpawnEnemy == 0:
		$EnemyFarmer.pick_item()
		spawn_unit(UnitOwnerEnum.ENEMY)


