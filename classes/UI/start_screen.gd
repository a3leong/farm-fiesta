extends CenterContainer

signal on_vs_cpu_pressed
signal on_vs_player_pressed

func _on_vs_cpu_pressed():
	on_vs_cpu_pressed.emit()


func _on_vs_player_pressed():
	on_vs_player_pressed.emit()
