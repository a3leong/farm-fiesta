extends Node

signal player_score_update
signal enemy_score_update

var player_score = 0
var enemy_score = 0

enum UNIT_OWNER {PLAYER, ENEMY}

func _set_score(unitOwner: UNIT_OWNER, score: int):
	if unitOwner == UNIT_OWNER.PLAYER:
		player_score = score
		player_score_update.emit(score)
	if unitOwner == UNIT_OWNER.ENEMY:
		enemy_score = score
		enemy_score_update.emit(score)

func inc_player_score():
	_set_score(UNIT_OWNER.PLAYER, player_score + 1)
	
func inc_enemy_score():
	_set_score(UNIT_OWNER.ENEMY, enemy_score + 1)