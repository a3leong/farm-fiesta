extends UnitState

enum {PLAYER,ENEMY}

signal bounced_twice

var bounceCount = 0
var emitted = false
var unitOwner

# System called on script init
func _init():
	set_as_inactive_state()

# Dev called init function
func init(initOwner):
	unitOwner = initOwner
	if unitOwner == UnitOwnerEnum.ENEMY:
		set_modulate(Color(255, 0, 0))

func set_as_active_state(curPos: Vector2):
	position = curPos
	show()
	call_deferred("set_process_mode", ProcessMode.PROCESS_MODE_INHERIT)
	
func set_as_inactive_state():
	hide()
	call_deferred("set_process_mode", ProcessMode.PROCESS_MODE_DISABLED)

func start_pluck(unitOwnerValue, thrownForce: Vector2):
	$RigidBody2D/AnimatedSprite2D.play("default")
	
	if unitOwnerValue == ENEMY:
		$RigidBody2D/AnimatedSprite2D.set_flip_h(true)
	
	unitOwner = unitOwnerValue
	$RigidBody2D.set_linear_velocity(Vector2(-thrownForce.x if unitOwnerValue == PLAYER else thrownForce.x, -thrownForce.y))

func _on_rigid_body_2d_body_entered(body):
	if body.name == "Ground":
		bounceCount += 1
	if bounceCount > 1 && !emitted:
		bounced_twice.emit($RigidBody2D.get_global_position())
		emitted = true
		queue_free() # TODO: seems a bit like a hard coded solution here

