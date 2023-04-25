extends UnitState

enum {PLAYER,ENEMY}

signal bounced_twice

var bounceCount = 0
var max_bounce = 1
var emitted = false
var unit_owner
var unit_type

# Note: Had to change the scale as an initial setting because setting dynamically makes the RigidBody2D just reset on the next frame

# System called on script init
func _init():
	set_as_inactive_state()

# Dev called init function
func init(init_owner, init_type, sf: SpriteFrames):
	unit_owner = init_owner
	unit_type = init_type
	$RigidBody2D/AnimatedSprite2D.set_sprite_frames(sf)
	if unit_owner == UnitOwnerEnum.VALUES.CPU:
		set_modulate(Color(100, 0, 0))

func set_as_active_state(curPos: Vector2):
	position = curPos
	show()
	call_deferred("set_process_mode", ProcessMode.PROCESS_MODE_INHERIT)
	
func set_as_inactive_state():
	hide()
	call_deferred("set_process_mode", ProcessMode.PROCESS_MODE_DISABLED)

func start_pluck(unit_owner_value, thrown_force: Vector2):
	$RigidBody2D/AnimatedSprite2D.play("default")
	
	if unit_owner_value == ENEMY:
		$RigidBody2D/AnimatedSprite2D.set_flip_h(true)
	
	unit_owner = unit_owner_value
	$RigidBody2D.set_linear_velocity(Vector2(-thrown_force.x if unit_owner_value == PLAYER else thrown_force.x, -thrown_force.y))

func _on_rigid_body_2d_body_entered(body):
	if body.name == "Ground":
		bounceCount += 1
	if bounceCount > max_bounce && !emitted:
		bounced_twice.emit($RigidBody2D.get_global_position())
		emitted = true
		queue_free() # TODO: seems a bit like a hard coded solution here

