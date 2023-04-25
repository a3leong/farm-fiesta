extends Area2D

var unit_owner: UnitOwnerEnum.VALUES

signal lose_area_entered

func set_unit_owner(the_unit_owner: UnitOwnerEnum.VALUES):
	unit_owner = the_unit_owner

func _on_area_entered(area: Area2D):
	if area.name == "UnitStateWalkingArea2D":
		lose_area_entered.emit(area.unit_owner)
