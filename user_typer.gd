extends Node

var cw = [] # No typing because static doesn't support nested arrays
var word_queue = []
var cw_index = 0

func _ready():
	_load_word()
	_load_word()
	_load_word()
	_load_next_cw()
	_update_label()
	
func _load_word():
	word_queue.push_back(["W","O","O","D","L","E"])

func _update_label():
	var front_word = _array_to_str(cw.slice(0, cw_index))
	var back_word = _array_to_str(cw.slice(cw_index, cw.size()))
	$CurrentWord.text = "[color=green]" + front_word + "[/color]" + back_word

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
	var next_word = word_queue.pop_front()
	_load_word()
	cw = next_word
	cw_index = 0

func _handle_word_submit():
	_load_next_cw()
	$PluckUpSFX.play()
	$Farmer.pick_item()

func _handle_bad_word():
	# Shake the word then disable input for X time
	print("handle bad word")
	_shake_current_word()
	set_process_unhandled_input(false)
	$PluckDownSFX.play()
	pass

func _shake_current_word():
	$AnimationPlayer.play("shake_word")

func _on_animation_player_animation_finished(anim_name):
	$AnimationPlayer.play("RESET")
	set_process_unhandled_input(true)
	
