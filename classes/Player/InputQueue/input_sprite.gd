extends Control

func _ready():
	$Z.set_visible(false)
	$X.set_visible(false)
	$C.set_visible(false)

func z():
	$Z.set_visible(true)
	$X.set_visible(false)
	$C.set_visible(false)

func x():
	$Z.set_visible(false)
	$X.set_visible(true)
	$C.set_visible(false)
	

func c():
	$Z.set_visible(false)
	$X.set_visible(false)
	$C.set_visible(true)
	
