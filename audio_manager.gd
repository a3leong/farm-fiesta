extends Node

func pluckUp(pitchScale):
	$PluckUp.set_pitch_scale(pitchScale)
	$PluckUp.play()
