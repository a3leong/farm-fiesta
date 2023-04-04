extends Node
@onready var word_list = get_node("/root/WordList")

var cw: Array[String] = []
var word_queue: Array[String] = []
var cw_index = 0

func _ready():
	_load_word()
	_load_word()
	_load_word()
	_load_next_cw()
	_update_label()
	
func _load_word():
	var new_word: String = word_list.get_word()
	new_word = new_word.to_upper()
	word_queue.push_back(new_word)

func _update_label():
	var front_word = _array_to_str(cw.slice(0, cw_index))
	var back_word = _array_to_str(cw.slice(cw_index, cw.size()))
	$WordContainer/CurrentWord.text = "[color=green]" + front_word + "[/color]" + back_word

func _array_to_str(word: Array) -> String:
	return word.reduce(func(accum: String, c: String): return accum + c, "")

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey && event.is_pressed():
		if event.keycode >= 65 && event.keycode <= 90:
			if cw_index > cw.size():
				push_error("Some kind of bug happened where cw_index passed the cw length, resetting input")
				cw_index = 0
			elif cw_index == cw.size() || event.as_text() != cw[cw_index]:
				_handle_bad_word()
			else:
				cw_index += 1
				$TypeChitSFX.play()
				$Farmer.pull_item()
		elif event.keycode == KEY_SPACE || event.keycode == KEY_ENTER || event.keycode == KEY_TAB:
			if cw_index != cw.size():
				_handle_bad_word()
			elif cw_index == cw.size():
				_handle_word_submit()

		_update_label()

func _load_next_cw():
	# Queue the next word and reset index
	var next_word: String = word_queue.pop_front()
	var next_word_array: Array[String] = []
	for c in next_word:
		next_word_array.push_back(c)
	cw = next_word_array
	cw_index = 0
	# Load more words and update the label texts
	_load_word()
	# TODO: make programmatic, but probably not worth the effort rn
	$WordContainer/HBoxContainer1/NextWord1.text = word_queue[0]
	$WordContainer/HBoxContainer2/NextWord2.text = word_queue[1]
	$WordContainer/HBoxContainer3/NextWord3.text = word_queue[2]
	


func _handle_word_submit():
	_load_next_cw()
	$PluckUpSFX.play()
	$Farmer.pick_item()

func _handle_bad_word():
	# Shake the word then disable input for X time
	_shake_current_word()
	$Farmer/AnimatedSprite2D.play("balk")
	$AnimationPlayer.play("exhausted")
	set_process_unhandled_input(false)
	$PluckDownSFX.play()
	pass

func _shake_current_word():
	var tween = get_tree().create_tween()
	var sp: Vector2 = $WordContainer/CurrentWord.get_position()
	tween.tween_property($WordContainer/CurrentWord, "position", Vector2(sp.x + 10, sp.y), 0.05)
	tween.tween_property($WordContainer/CurrentWord, "position", Vector2(sp.x - 10, sp.y), 0.05)
	tween.tween_property($WordContainer/CurrentWord, "position", Vector2(sp.x + 5, sp.y), 0.05)
	tween.tween_property($WordContainer/CurrentWord, "position", Vector2(sp.x - 5, sp.y), 0.05)
	tween.tween_property($WordContainer/CurrentWord, "position", Vector2(sp.x + 3, sp.y), 0.05)
	tween.tween_property($WordContainer/CurrentWord, "position", Vector2(sp.x - 3, sp.y), 0.05)
	tween.tween_property($WordContainer/CurrentWord, "position", Vector2(sp.x + 1, sp.y), 0.05)
	tween.tween_property($WordContainer/CurrentWord, "position", Vector2(sp.x, sp.y), 0.05)
	
	var tween2 = get_tree().create_tween()
	var sp2: Vector2 = $Farmer.get_position()
	tween2.tween_property($Farmer, "position", Vector2(sp2.x + 10, sp2.y), 0.05)
	tween2.tween_property($Farmer, "position", Vector2(sp2.x - 10, sp2.y), 0.05)
	tween2.tween_property($Farmer, "position", Vector2(sp2.x + 5, sp2.y), 0.05)
	tween2.tween_property($Farmer, "position", Vector2(sp2.x - 5, sp2.y), 0.05)
	tween2.tween_property($Farmer, "position", Vector2(sp2.x + 3, sp2.y), 0.05)
	tween2.tween_property($Farmer, "position", Vector2(sp2.x - 3, sp2.y), 0.05)
	tween2.tween_property($Farmer, "position", Vector2(sp2.x + 1, sp2.y), 0.05)
	tween2.tween_property($Farmer, "position", Vector2(sp2.x - 1, sp2.y), 0.05)

func _on_animation_player_animation_finished(anim_name):
	set_process_unhandled_input(true)
	
