extends Control

signal debugSpawnPlayerUnit
signal debugSpawnEnemyUnit

@onready var game_variables = get_node("/root/GameVariables")

func _ready():
	# Connect signals from globals
	game_variables.player_score_update.connect(_handlePlayerScoreUpdate)
	game_variables.enemy_score_update.connect(_handleEnemyScoreUpdate)

func _handlePlayerScoreUpdate(score):
	_update_player_pts(score)

func _handleEnemyScoreUpdate(score):
	_update_enemy_pts(score)

func _on_spawn_player_pressed():
	debugSpawnPlayerUnit.emit()

func _on_spawn_enemy_pressed():
	debugSpawnEnemyUnit.emit()

func _update_player_pts(pts: int):
	$GridContainer/PlayerPts.set_text("Player pts: " + str(pts))

func _update_enemy_pts(pts: int):
	$GridContainer/EnemyPts.set_text("Enemy pts: " + str(pts))
