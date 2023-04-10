extends Control
class_name InputSprite

func none():
	$Z.set_visible(false)
	$X.set_visible(false)
	$C.set_visible(false)
	$Left.set_visible(false)
	$Down.set_visible(false)
	$Right.set_visible(false)

func z():
	none()
	$Z.set_visible(true)

func x():
	none()
	$X.set_visible(true)
	

func c():
	none()
	$C.set_visible(true)
	
func left():
	none()
	$Left.set_visible(true)

func down():
	none()
	$Down.set_visible(true)

func right():
	none()
	$Right.set_visible(true)
