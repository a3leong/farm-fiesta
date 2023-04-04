extends Area2D

func _ready():
	init()

func init() -> void:
	$AnimatedSprite2D.stop()

func pick_item() -> void:
	# Make the animation play faster when not done yet to handle rapid presses
	if $AnimatedSprite2D.is_playing():
		$AnimatedSprite2D.frame = 1
	else:
		$AnimatedSprite2D.frame = 0
	$AnimatedSprite2D.play("pick")
	
func pull_item() -> void:
	$AnimatedSprite2D.frame = 0
	$AnimatedSprite2D.play("pull")
