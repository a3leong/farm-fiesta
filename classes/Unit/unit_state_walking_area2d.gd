extends Area2D
# This script exists to hold the unit owner property

var unitOwner = UnitOwnerEnum.PLAYER

func init(newUnitOwner: int):
	unitOwner = newUnitOwner
