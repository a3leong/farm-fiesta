extends Control
class_name InputSprite

func none():
	$Left.set_visible(false)
	$Middle.set_visible(false)
	$Right.set_visible(false)

func left():
	none()
	$Left.set_visible(true)

func middle():
	none()
	$Middle.set_visible(true)

func right():
	none()
	$Right.set_visible(true)
