extends UnitState

var speed: float = 100

var isWalking = false
var unitOwner

signal unit_collision

# System called on script init
func _init():
	set_as_inactive_state()

# Dev called init function
func init(initOwner):
	unitOwner = initOwner
	$Area2D.init(unitOwner)
	if unitOwner == UnitOwnerEnum.ENEMY:
		$Area2D/AnimatedSprite2D.set_flip_h(true)
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


func _on_area_2d_area_entered(area):
	if unitOwner != area.unitOwner:
		unit_collision.emit($Area2D, area)
