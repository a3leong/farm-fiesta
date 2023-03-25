extends Node2D

class_name Unit

@export var speed = 100
@export var health = 1
@export var damage = 1


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
		set_modulate(Color(248, 0, 33))

func _ready():
	print("Unit ready")
	

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
