extends Node2D

@export var speed = 100

## A unit wrapper for managing and handling multiple states of a single unit
##
## Displays and hides states as well as serving as a communication bridge between
## the main scene and child nodes via signals
##
## @tutorial:            http://the/tutorial1/url.com
## @tutorial(Tutorial2): http://the/tutorial2/url.com

# TODO: Actually figure out how to explicit the enum from another class
var activeState: int = UnitStateEnum.NONE # No init state to keep it explicit
var unitOwner: int = UnitOwnerEnum.PLAYER

func init(initOwner: int):
	$UnitStateWalking.init(initOwner)
	$UnitStatePluck.init(initOwner)

## _get_current_position()
##
## Get the current position of object based on the active object
## TODO: I don't think this should apply to this case but special case needs to be made to
## actually set the position on a rigidbody2D after it's been spawned
func _get_current_position() -> Vector2:
	match(activeState):
		UnitStateEnum.WALKING:
			return $UnitStateWalking.position
		UnitStateEnum.PLUCK:
			return $UnitStatePluck/RigidBody2D.position
	
	print("No matching state found!")
	return Vector2(0.0, 0.0) # Should not hit this but just in case
## set_state()
##
## Abstraction layer for setting active unit state
func set_state(state: int, currentPos: Vector2):
	activeState = state
	match(state):
		UnitStateEnum.WALKING:
			_set_state_walking(currentPos)
		UnitStateEnum.PLUCK:
			_set_state_pluck(currentPos)
			
## call_state()
##
## Abstraction fn for calling a function with args for a unit state
func call_state(state: int, method: String, args: Array):
	match(state):
		UnitStateEnum.WALKING:
			$UnitStateWalking.callv(method, args)
		UnitStateEnum.PLUCK:
			$UnitStatePluck.callv(method, args)
	
## _hidStates()
## Help fn to hide all states except those in the exception list
##
## exceptions -- State names to exclude in hiding
func _hide_states(exceptions: Dictionary):
	if !exceptions.has(UnitStateEnum.WALKING):
		$UnitStateWalking.set_as_inactive_state()
	if !exceptions.has(UnitStateEnum.PLUCK):
		$UnitStatePluck.set_as_inactive_state()

func _set_state_walking(currentPos: Vector2):
	_hide_states({ UnitStateEnum.WALKING: true })
	var positionToSet = currentPos if currentPos else _get_current_position()
	$UnitStateWalking.set_as_active_state(positionToSet)
	$UnitStateWalking.start_walk()

func _set_state_pluck(currentPos: Vector2):
	_hide_states({ UnitStateEnum.PLUCK: true })
	var positionToSet = currentPos if currentPos else _get_current_position()
	$UnitStatePluck.set_as_active_state(positionToSet)


func _on_unit_state_pluck_bounced_twice(globalPosition: Vector2):
	set_state(UnitStateEnum.WALKING, globalPosition)
