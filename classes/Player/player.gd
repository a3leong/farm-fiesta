extends Node2D
@export var unit_scene: PackedScene
@onready var audio_manager = get_node("/root/AudioManager")
@export var spawn_throw_force = Vector2(100, 400)
@export var spawn_throw_variance_y = 300
@export var spawn_throw_variance_x = 50

signal unit_spawned

var unit_owner: UnitOwnerEnum.VALUES = UnitOwnerEnum.VALUES.PLAYER1
var playerResourceLoader: PlayerResourceLoader = PlayerResourceLoader.new()

#######################
# Public fns
#######################
func get_unit_owner() -> UnitOwnerEnum.VALUES:
	return unit_owner

func init(init_unit_owner: UnitOwnerEnum.VALUES, skin: String) -> void:
	show()
	set_unit_owner(init_unit_owner)
	# Frames will load on init and be available to pass on demand
	playerResourceLoader.init(skin)

func reset_player():
	# No need to call init since main will call init again
	$InputQueue.set_process_input(false)
	hide()

# Handles anything to do with logic unique to unit owner type
func set_unit_owner(init_unit_owner: UnitOwnerEnum.VALUES):
	unit_owner = init_unit_owner
	$InputQueue.init(unit_owner)
	if unit_owner == UnitOwnerEnum.VALUES.CPU:
		$InputQueue.hide()
		$InputQueue.set_process_input(false)
	else:
		$InputQueue.set_process_input(true)
	if unit_owner == UnitOwnerEnum.VALUES.CPU || unit_owner == UnitOwnerEnum.VALUES.PLAYER2:
		var old_scale: Vector2 = get_scale()
		set_scale(Vector2(-old_scale.x, old_scale.y))

func spawn_unit(unit_type: UnitTypeEnum.VALUES):
	$PlayerCharacter.pick_item() # TODO: Not sure where this should go since enemy unit needs to be able to spawn too
	# Let main handle signal connect
	var spawned_scene = unit_scene.instantiate()
	var start_position: Vector2 = $UnitSpawnPosition.get_global_position()
#	spawned_scene.set_scale(Vector2(1.2, 1.2))
	var pluck_force = _generateRandomPluck2DVector()
	
	var pluckSFXPitchScale = ((pluck_force.y - spawn_throw_force.y) / spawn_throw_variance_y * .25) + .75
	spawned_scene.init(unit_owner, unit_type, $PlayerCharacter.get_global_position().y, playerResourceLoader)
	spawned_scene.set_state(UnitStateEnum.VALUES.PLUCK, start_position)
	spawned_scene.call_state(UnitStateEnum.VALUES.PLUCK, "start_pluck", [unit_owner, pluck_force])
	audio_manager.pluck_up(pluckSFXPitchScale)
	unit_spawned.emit(spawned_scene)


######################
# Private functions
######################
func _generateRandomPluck2DVector():
	var xForce = spawn_throw_force.x + randi() % spawn_throw_variance_x
	var yVariance = randi() % spawn_throw_variance_y
	var yForce = spawn_throw_force.y + yVariance
	return Vector2(xForce, yForce)

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "exhausted":
		$InputQueue.set_process_input(true)
		$PlayerCharacter/AnimatedSprite2D.stop()
		$PlayerCharacter/AnimatedSprite2D.set_animation("pick")

func _shake_animation():
	var tween = get_tree().create_tween()
	var start_pt: Vector2 = $PlayerCharacter.get_position()
	tween.tween_property($PlayerCharacter, "position", Vector2(start_pt.x + 5, start_pt.y), 0.05)
	tween.tween_property($PlayerCharacter, "position", Vector2(start_pt.x - 5, start_pt.y), 0.05)
	tween.tween_property($PlayerCharacter, "position", Vector2(start_pt.x + 4, start_pt.y), 0.05)
	tween.tween_property($PlayerCharacter, "position", Vector2(start_pt.x - 4, start_pt.y), 0.05)
	tween.tween_property($PlayerCharacter, "position", Vector2(start_pt.x + 3, start_pt.y), 0.05)
	tween.tween_property($PlayerCharacter, "position", Vector2(start_pt.x - 3, start_pt.y), 0.05)
	tween.tween_property($PlayerCharacter, "position", Vector2(start_pt.x + 2, start_pt.y), 0.05)
	tween.tween_property($PlayerCharacter, "position", Vector2(start_pt.x - 2, start_pt.y), 0.05)
	tween.tween_property($PlayerCharacter, "position", Vector2(start_pt.x + 1, start_pt.y), 0.05)
	tween.tween_property($PlayerCharacter, "position", Vector2(start_pt.x - 1, start_pt.y), 0.05)

######################################
# Signal handlers and inherited fns
######################################
func _ready():
	reset_player()

func _on_input_queue_correct_input(unit_type: UnitTypeEnum.VALUES):
	spawn_unit(unit_type)

func _on_input_queue_wrong_input():
	# Shake the letter and character then disable input for X time
	_shake_animation()
	$InputQueue.set_process_input(false)
	$PlayerCharacter/AnimatedSprite2D.play("balk")
	$AnimationPlayer.play("exhausted")
	audio_manager.balk()
