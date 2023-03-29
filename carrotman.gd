extends RigidBody2D

class_name Unit

@export var speed = 100
@export var health = 1
@export var damage = 1

enum {PLAYER,ENEMY}

signal collide

var unitOwner = -1 # needs to be set, -1 to prevent crashing
var isMoving = false
var isHittible = true

func init(unitOwnerValue, spawnPosition, thrownForce: Vector2):
	unitOwner = unitOwnerValue
	position = spawnPosition
	if unitOwner == ENEMY:
		speed = -speed # go backwards
		$AnimatedSprite2D.flip_h = true
		set_modulate(Color(255, 200, 225))
	set_linear_velocity(Vector2(-thrownForce.x if unitOwnerValue == PLAYER else thrownForce.x, -thrownForce.y))

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


# TODO: Probably need to add a parent node that controls and manages a rigidbody and an area2d
# TODO: This is currently on used because of change to physics 2d
# TODO: differentiate between enemy unit collision, ground collision, ignore team collision
func _on_area_entered(area):
	print("on area entered")
	# Check for opposing unit collision otherwise ignore
	if (area.get_scene_file_path() == get_scene_file_path() && area.unitOwner != unitOwner): # This should check for same scene type (name will be unique)
		print(area.unitOwner)
		onCollide()



func _on_body_entered(body):
	print("on body entered carrot")
