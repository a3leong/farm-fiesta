extends Control

signal debugSpawnPlayerUnit
signal debugSpawnEnemyUnit

func _on_spawn_player_pressed():
	debugSpawnPlayerUnit.emit()


func _on_spawn_enemy_pressed():
	debugSpawnEnemyUnit.emit()
