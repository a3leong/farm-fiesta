extends Node

func pluck_up(pitch_scale):
	$PluckUp.set_pitch_scale(pitch_scale)
	$PluckUp.play()

func balk():
	$Balk.play()

func type_sound():
	$TypeChit.play()
