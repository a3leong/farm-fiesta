extends Node2D
@export var unit_scene: PackedScene = preload("res://classes/Player/Unit/unit.tscn")
@onready var word_list = get_node("/root/WordList")
@onready var audio_manager = get_node("/root/AudioManager")
@export var spawn_throw_force = Vector2(100, 400)
@export var spawn_throw_variance_y = 300
@export var spawn_throw_variance_x = 50

signal unit_spawned

# TODO: Is there a window where a user can input before current_input is set?

var unit_owner: UnitOwnerEnum.VALUES = UnitOwnerEnum.VALUES.PLAYER
var input_queue: Array[UnitTypeEnum.VALUES] = []
var current_input: UnitTypeEnum.VALUES
var cw: Array[String] = []
var word_queue: Array[String] = []
var cw_index = 0

func set_unit_owner(init_unit_owner: UnitOwnerEnum.VALUES):
	unit_owner = init_unit_owner
	if unit_owner == UnitOwnerEnum.VALUES.ENEMY:
		$InputSprite.hide()
		set_scale(Vector2(-1.0, 1.0))
		set_process_input(false)


func _queue_inputs():
	current_input = input_queue.pop_front()
	var new_input: UnitTypeEnum.VALUES = UnitTypeEnum.VALUES.values()[randi() % UnitTypeEnum.VALUES.size()]
	input_queue.push_back(new_input)
	
# Updates the text values of labels
func _update_labels():
	match current_input:
		UnitTypeEnum.VALUES.ROCK:
			$InputSprite.z()
		UnitTypeEnum.VALUES.PAPER:
			$InputSprite.x()
		UnitTypeEnum.VALUES.SCISSORS:
			$InputSprite.c()
#	$InputQueue2D/InputQueue/InputsLabel.text = "[color=green]" + _get_key_from_unit_type(current_input) + "[/color]"
	
#	for type in input_queue:
#		$InputQueue2D/InputQueue/InputsLabel.text += "  " + _get_key_from_unit_type(type)
	
func _ready():
	# Fill the input queue
	for idx in range(5):
		input_queue.push_back(UnitTypeEnum.VALUES.values()[randi() % UnitTypeEnum.VALUES.size()])
	_queue_inputs() # Set the first unit inpput
	_update_labels()

func _input(event: InputEvent) -> void:	
	var unit_type = null
	if event.is_action_pressed("p1_rock"):
		unit_type = UnitTypeEnum.VALUES.ROCK
	elif event.is_action_pressed("p1_paper"):
		unit_type = UnitTypeEnum.VALUES.PAPER	
	elif event.is_action_pressed("p1_scissors"):
		unit_type = UnitTypeEnum.VALUES.SCISSORS
		
	if unit_type != null:
		if unit_type == current_input:
			_handle_correct_input()
		else:
			_handle_bad_input()

func _handle_correct_input():
	_queue_inputs()
	_update_labels()
	spawn_unit(current_input)

func _handle_bad_input():
	# Shake the letter and character then disable input for X time
	_shake_animation()
	$PlayerCharacter/AnimatedSprite2D.play("balk")
	$AnimationPlayer.play("exhausted")
	set_process_input(false)
	audio_manager.balk()

func _shake_animation():
	# TODO: See if this should be done for the input
#	var tween = get_tree().create_tween()
#	var sp: Vector2 = $WordContainer/CurrentWord.get_position()
#	tween.tween_property($WordContainer/CurrentWord, "position", Vector2(sp.x + 10, sp.y), 0.05)
#	tween.tween_property($WordContainer/CurrentWord, "position", Vector2(sp.x - 10, sp.y), 0.05)
#	tween.tween_property($WordContainer/CurrentWord, "position", Vector2(sp.x + 5, sp.y), 0.05)
#	tween.tween_property($WordContainer/CurrentWord, "position", Vector2(sp.x - 5, sp.y), 0.05)
#	tween.tween_property($WordContainer/CurrentWord, "position", Vector2(sp.x + 3, sp.y), 0.05)
#	tween.tween_property($WordContainer/CurrentWord, "position", Vector2(sp.x - 3, sp.y), 0.05)
#	tween.tween_property($WordContainer/CurrentWord, "position", Vector2(sp.x + 1, sp.y), 0.05)
#	tween.tween_property($WordContainer/CurrentWord, "position", Vector2(sp.x, sp.y), 0.05)
#
	var tween2 = get_tree().create_tween()
	var sp2: Vector2 = $PlayerCharacter.get_position()
	tween2.tween_property($PlayerCharacter, "position", Vector2(sp2.x + 10, sp2.y), 0.05)
	tween2.tween_property($PlayerCharacter, "position", Vector2(sp2.x - 10, sp2.y), 0.05)
	tween2.tween_property($PlayerCharacter, "position", Vector2(sp2.x + 5, sp2.y), 0.05)
	tween2.tween_property($PlayerCharacter, "position", Vector2(sp2.x - 5, sp2.y), 0.05)
	tween2.tween_property($PlayerCharacter, "position", Vector2(sp2.x + 3, sp2.y), 0.05)
	tween2.tween_property($PlayerCharacter, "position", Vector2(sp2.x - 3, sp2.y), 0.05)
	tween2.tween_property($PlayerCharacter, "position", Vector2(sp2.x + 1, sp2.y), 0.05)
	tween2.tween_property($PlayerCharacter, "position", Vector2(sp2.x - 1, sp2.y), 0.05)

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "exhausted":
		set_process_input(true)
		$PlayerCharacter/AnimatedSprite2D.stop()
		$PlayerCharacter/AnimatedSprite2D.set_animation("pick")
		
func _generateRandomPluck2DVector():
	var xForce = spawn_throw_force.x + randi() % spawn_throw_variance_x
	var yVariance = randi() % spawn_throw_variance_y
	var yForce = spawn_throw_force.y + yVariance
	return Vector2(xForce, yForce)

func spawn_unit(unit_type: UnitTypeEnum.VALUES):
	$PlayerCharacter.pick_item() # TODO: Not sure where this should go since enemy unit needs to be able to spawn too
	# Let main handle signal connect
	var spawned_scene = unit_scene.instantiate()
	var start_position: Vector2 = $UnitSpawnPosition.get_global_position()
	var pluck_force = _generateRandomPluck2DVector()

	var pluckSFXPitchScale = ((pluck_force.y - spawn_throw_force.y) / spawn_throw_variance_y * .25) + .75
	spawned_scene.init(unit_owner, unit_type, $PlayerCharacter.get_global_position().y)
	spawned_scene.set_state(UnitStateEnum.VALUES.PLUCK, start_position)
	spawned_scene.call_state(UnitStateEnum.VALUES.PLUCK, "start_pluck", [unit_owner, pluck_force])
	audio_manager.pluck_up(pluckSFXPitchScale)
	unit_spawned.emit(spawned_scene)

static func _get_key_from_unit_type(unit_type: UnitTypeEnum.VALUES) -> String:
	if unit_type == UnitTypeEnum.VALUES.ROCK:
		return "Z"
	elif unit_type == UnitTypeEnum.VALUES.PAPER:
		return "X"
	elif unit_type == UnitTypeEnum.VALUES.SCISSORS:
		return "C"
	else:
		push_error("No unit type recognized")
		return "-"

