extends UnitState

var speed: float = 100

var isWalking = false
var unitOwner

# System called on script init
func _init():
	set_as_inactive_state()

# Dev called init function
func init(initOwner):
	unitOwner = initOwner
	if unitOwner == UnitOwnerEnum.ENEMY:
		speed = -speed
		set_modulate(Color(255, 0, 0))

func start_walk():
	isWalking = true
	$Area2D/AnimatedSprite2D.play("default")
	
func stop_walk():
	isWalking = false
	$Area2D/AnimatedSprite2D.stop()

func _process(delta: float):
	if isWalking:
		position.x += delta * speed
