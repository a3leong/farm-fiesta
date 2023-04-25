extends UnitState

var speed: float = 100

var isWalking = false
var unit_owner
var unit_type

signal unit_collision

# TODO: Make the Area2D new scenes with interchangibility since there's most likely going to be less units than skins later on

# System called on script init
func _init():
	set_as_inactive_state()

# Dev called init function
func init(init_owner: UnitOwnerEnum.VALUES, init_type: UnitTypeEnum.VALUES, sf: SpriteFrames):
	unit_owner = init_owner
	unit_type = init_type
	$UnitStateWalkingArea2D.init(unit_owner, init_type)
	$UnitStateWalkingArea2D/AnimatedSprite2D.set_sprite_frames(sf)
	if unit_owner == UnitOwnerEnum.VALUES.CPU || unit_owner == UnitOwnerEnum.VALUES.PLAYER2:
		$UnitStateWalkingArea2D/AnimatedSprite2D.set_flip_h(true)
		speed = -speed
		set_modulate(Color(255, 0, 0))

func start_walk():
	isWalking = true
	_play_animation()
	
func stop_walk():
	isWalking = false
	$UnitStateWalkingArea2D/AnimatedSprite2D.stop()

func _process(delta: float):
	if isWalking:
		position.x += delta * speed


func _on_area_2d_area_entered(area: Area2D):
	# Only respond to other unitStateWalking, ignore other
	if unit_owner != area.unit_owner:
		unit_collision.emit($UnitStateWalkingArea2D, area)
	# TOOD: How to check for enemy and player scene names without dumb hardcoding
	if area.name == "UnitStateWalkingArea2D":
		if unit_owner != area.unit_owner:
			unit_collision.emit($UnitStateWalkingArea2D, area)
## Picks correct animation based on unit type
func _play_animation():
	match unit_type:
		UnitTypeEnum.VALUES.ROCK:
			$UnitStateWalkingArea2D/AnimatedSprite2D.play("rock")
			$UnitStateWalkingArea2D/CollisionShape2D.shape.set_size(Vector2(11,14))
		UnitTypeEnum.VALUES.PAPER:
			$UnitStateWalkingArea2D/AnimatedSprite2D.play("paper")
			$UnitStateWalkingArea2D/CollisionShape2D.shape.set_size(Vector2(20,17))
		UnitTypeEnum.VALUES.SCISSORS:
			$UnitStateWalkingArea2D/AnimatedSprite2D.play("scissors")
			$UnitStateWalkingArea2D/CollisionShape2D.shape.set_size(Vector2(12,24))
