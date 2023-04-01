extends UnitState

var speed: float = 100

var isWalking = false
var unit_owner
var unit_type

signal unit_collision

# TODO: Make the Area2D new scenes with interchangibility

# System called on script init
func _init():
	set_as_inactive_state()

# Dev called init function
func init(init_owner: UnitOwnerEnum.VALUES, init_type: UnitTypeEnum.VALUES):
	unit_owner = init_owner
	unit_type = init_type
	$Area2D.init(unit_owner, init_type)
	if unit_owner == UnitOwnerEnum.VALUES.ENEMY:
		$Area2D/AnimatedSprite2D.set_flip_h(true)
		speed = -speed
		set_modulate(Color(255, 0, 0))

func start_walk():
	isWalking = true
	_play_animation()
	
func stop_walk():
	isWalking = false
	$Area2D/AnimatedSprite2D.stop()

func _process(delta: float):
	if isWalking:
		position.x += delta * speed


func _on_area_2d_area_entered(area):
	if unit_owner != area.unit_owner:
		unit_collision.emit($Area2D, area)

## Picks correct animation based on unit type
func _play_animation():
	match unit_type:
		UnitTypeEnum.VALUES.ROCK:
			$Area2D/AnimatedSprite2D.play("rock")
		UnitTypeEnum.VALUES.PAPER:
			$Area2D/AnimatedSprite2D.play("paper")
		UnitTypeEnum.VALUES.SCISSORS:
			$Area2D/AnimatedSprite2D.play("scissors")
