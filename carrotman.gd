extends RigidBody2D

class_name Unit

@export var speed = 100
@export var health = 1
@export var damage = 1
@export var spawn_throw_force = Vector2(100, 400)
@export var spawn_throw_variance_y = 300
@export var spawn_throw_variance_x = 50


enum {PLAYER,ENEMY}

signal collide

var unitOwner = -1 # needs to be set, -1 to prevent crashing
var isMoving = false
var isHittible = true

func init(unitOwnerValue, spawnPosition):
	unitOwner = unitOwnerValue
	position = spawnPosition
	if unitOwner == ENEMY:
		speed = -speed # go backwards
		$AnimatedSprite2D.flip_h = true
		set_modulate(Color(255, 200, 225))

func _ready():
	var xForce = spawn_throw_force.x + randi() % spawn_throw_variance_x
	if unitOwner == ENEMY:
		xForce = -xForce
	var yForce = spawn_throw_force.y + randi() % spawn_throw_variance_y
	print("xForce " + str(xForce) + " yForce " + str(yForce))
	set_linear_velocity(Vector2(-xForce, -yForce))
	$CollisionShape2D.disabled = true # Until hits ground don't hit other units
	

func _process(delta):
	if isMoving:
		position.x += speed * delta
	
	
func startMoving():
	$AnimatedSprite2D.play()
	isMoving = true

func stopMoving():
	$AnimatedSprite2D.stop()
	isMoving = false

# Let game logic manager decide what happens between 2 different units
# and it'll be responsible for triggering their death fns
func onCollide():

	print("Collision detected")
	collide.emit()
	onDie()

# Turn off collision capability and play death animation then delete obj
func onDie():
	print("Unit died")
	queue_free()


func _on_area_entered(area):
	# Check for opposing unit collision otherwise ignore
	if (area.get_scene_file_path() == get_scene_file_path() && area.unitOwner != unitOwner): # This should check for same scene type (name will be unique)
		print(area.unitOwner)
		onCollide()
