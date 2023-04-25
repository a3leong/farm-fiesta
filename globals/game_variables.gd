extends Node

signal player_score_update
signal enemy_score_update
signal spawn_speed_update

signal player_health_update
signal player_ko
signal enemy_health_update
signal enemy_ko

var player_score = 0
var enemy_score = 0
var init_spawn_speed = 3
var enemy_spawn_speed = init_spawn_speed

var player_health: int = 100
var enemy_health: int = 100

enum UNIT_OWNER {PLAYER, ENEMY}

func reset_state():
	player_health = 100
	enemy_health = 100
	enemy_spawn_speed = init_spawn_speed
	
func get_player_health() -> int:
	return player_health

func get_enemy_health() -> int:
	return enemy_health

func set_player_health(health: int) -> void:
	player_health = health
	player_health_update.emit(health)
	if player_health <= 0:
		player_ko.emit()
		
func set_enemy_health(health: int) -> void:
	enemy_health = health
	enemy_health_update.emit(health)
	if enemy_health <= 0:
		enemy_ko.emit()

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
	
func set_spawn_speed(new_speed: float) -> void:
	enemy_spawn_speed = new_speed
	spawn_speed_update.emit(new_speed)
