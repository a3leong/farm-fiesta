extends Node2D
@export var carrotmanScene: PackedScene
@export var enemySpawnSpeed = 0.25
@export var spawn_throw_force = Vector2(100, 400)
@export var spawn_throw_variance_y = 300
@export var spawn_throw_variance_x = 50

const carrotManEmitter = preload("res://carrotman.tscn")

# TODO: import this instead of duplicating enum
enum {PLAYER,ENEMY}

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
		
	var pluckForceVector = _generateRandomPluck2DVector()
	var pluckSFXPitchScale = ((pluckForceVector.y - spawn_throw_force.y) / spawn_throw_variance_y * .25) + .75
	print(pluckSFXPitchScale)
	spawnedUnit.init(unitOwner, startPosition, pluckForceVector)
	spawnedUnit.startMoving()
	$AudioManager.pluckUp(pluckSFXPitchScale)
	add_child(spawnedUnit)


func _on_enemy_farmer_pick_timer_timeout():
	# Attempt to randomize to simulate player input
	var shouldSpawnEnemy = randi() % 2 # Gives random value between 0 and 1
	if shouldSpawnEnemy == 0:
		$EnemyFarmer.pick_item()
		spawnUnit(ENEMY)


func _on_ground_body_entered(body):
	print("notice body enter")
