extends Control

@onready var audio_manager = get_node("/root/AudioManager")
@onready var game_variables = get_node("/root/GameVariables")

var init_position: Vector2
var unit_owner: UnitOwnerEnum.VALUES

##############
# Public fns
#############
func init(the_unit_owner: UnitOwnerEnum.VALUES):
	unit_owner = the_unit_owner
	# Connect signals from globals
	if unit_owner == UnitOwnerEnum.VALUES.PLAYER1:
		game_variables.player_health_update.connect(_handleHealthUpdate)
	else:
		game_variables.enemy_health_update.connect(_handleHealthUpdate)

func hurt():
	# TODO this class can handle shake anims
	audio_manager.hurt() 
	$Portrait.play("hurt")
	$HurtPortraitTimer.start()
	_shake_portrait()
	
func neutral():
	$Portrait.play("neutral")

###############
# Overloaded fns
###############
func _ready():

	init_position = $Portrait.get_position()
	$Portrait.play("neutral")

######################
# Private fns
######################
func _shake_portrait():
	var tween = get_tree().create_tween()
	var start_pt: Vector2 = init_position # If too many of the function are called at once, can't use get position anymore
	
	var inc_value: float = 10.0
	var sub_val: float = 5.0
	var shake_speed: float = 0.01
	
	while inc_value > 0:
		tween.tween_property($Portrait, "position", Vector2(start_pt.x + inc_value, start_pt.y + inc_value), shake_speed)
		tween.tween_property($Portrait, "position", Vector2(start_pt.x - inc_value, start_pt.y - inc_value), shake_speed)
		tween.tween_property($Portrait, "position", Vector2(start_pt.x + inc_value, start_pt.y - inc_value), shake_speed)
		tween.tween_property($Portrait, "position", Vector2(start_pt.x - inc_value, start_pt.y + inc_value), shake_speed)
		inc_value -= sub_val
		sub_val = max(sub_val / 2.0, 1)
	# Reset at end
	tween.tween_property($Portrait, "position", start_pt, shake_speed)


######################
# Handler fns
######################
# TODO: There's gotta be a better way to smart hookup these signals
func _handleHealthUpdate(new_health: int):
	$TextureProgressBar.set_value(new_health)

func _on_hurt_portrait_timer_timeout():
	$Portrait.play("neutral")
