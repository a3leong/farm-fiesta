extends Node2D
class_name UnitState

func set_as_active_state(curPos: Vector2):
	position = curPos
	show()
	set_process_mode(ProcessMode.PROCESS_MODE_INHERIT)
	
func set_as_inactive_state():
	hide()
	set_process_mode(ProcessMode.PROCESS_MODE_DISABLED)
