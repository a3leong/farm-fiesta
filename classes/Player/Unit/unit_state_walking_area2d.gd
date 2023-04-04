extends Area2D
# This script exists to hold the unit owner property

var unit_owner: UnitOwnerEnum.VALUES = UnitOwnerEnum.VALUES.PLAYER
var unit_type: UnitTypeEnum.VALUES = UnitTypeEnum.VALUES.ROCK

func init(init_owner: UnitOwnerEnum.VALUES, init_type):
	unit_owner = init_owner
	unit_type = init_type
