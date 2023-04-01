extends Control
@onready var game_variables = get_node("/root/GameVariables")

var counter = 0
var gradualCounter = 0 # Make counter fill more gradual
var start_speed = 5
var speed = start_speed
var deacceleration = 1.5
var minSpeed = 0.5

func _process(delta):
	if gradualCounter < counter:
		gradualCounter += speed
		if speed > 0.5:
			speed /= deacceleration
		if gradualCounter > counter:
			gradualCounter = counter
		($TextureProgressBar as TextureProgressBar).set_value(gradualCounter)
	else:
		speed = start_speed

func _ready():
	# Connect signals from globals
	game_variables.player_score_update.connect(_handlePlayerScoreUpdate)

func _handlePlayerScoreUpdate(score):
	counter = score
