extends Area2D

@export var isEnemy = false


var animation_playing = false

func _ready():
	init()

func init():
	if isEnemy:
		$AnimatedSprite2D.flip_h = true
	$AnimatedSprite2D.stop()

func pick_item():
	# Make the animation play faster when not done yet to handle rapid presses
	if $AnimatedSprite2D.is_playing():
		$AnimatedSprite2D.frame = 1
	else:
		$AnimatedSprite2D.frame = 0
	$AnimatedSprite2D.play("pick")
	
func pull_item():
	$AnimatedSprite2D.frame = 0
	$AnimatedSprite2D.play("pull")

func _on_animated_sprite_2d_animation_finished():
	animation_playing = false
