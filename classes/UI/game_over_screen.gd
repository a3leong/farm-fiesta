extends CenterContainer

signal reset_1p
signal reset_2p
signal quit


func _on_reset_1p_pressed():
	reset_1p.emit()


func _on_reset_2p_pressed():
	reset_2p.emit()


func _on_quit_pressed():
	quit.emit()
