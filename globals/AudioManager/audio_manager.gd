extends Node

func pluck_up(pitch_scale):
	$PluckUp.set_pitch_scale(pitch_scale)
	$PluckUp.play()

func exhaust():
	$PluckDown.play()

func type_sound():
	$TypeChit.play()
