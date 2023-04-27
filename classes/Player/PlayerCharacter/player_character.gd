extends Area2D

func init(prl: PlayerResourceLoader) -> void:
	$AnimatedSprite2D.set_sprite_frames(prl.sf_player_character)
	$AnimatedSprite2D.stop()

func set_pick() -> void:
	$AnimatedSprite2D.set_animation("pick")

func pick() -> void:
	# Make the animation play faster when not done yet to handle rapid presses
	if $AnimatedSprite2D.is_playing():
		$AnimatedSprite2D.frame = 1
	else:
		$AnimatedSprite2D.frame = 0
	$AnimatedSprite2D.play("pick")

func balk() -> void:
	$AnimatedSprite2D.play("balk")

func stop() -> void:
	$AnimatedSprite2D.stop()
