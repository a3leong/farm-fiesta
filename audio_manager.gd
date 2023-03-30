extends Node

func pluck_up(pitchScale):
	$PluckUp.set_pitch_scale(pitchScale)
	$PluckUp.play()
