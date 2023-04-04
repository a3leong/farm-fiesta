extends Node2D

@export var speed = 100
var floorHeight = 48
var ground_y_position: float = 0.0
signal unit_collide

## A unit wrapper for managing and handling multiple states of a single unit
##
## Displays and hides states as well as serving as a communication bridge between
## the main scene and child nodes via signals
##
## @tutorial:            http://the/tutorial1/url.com
## @tutorial(Tutorial2): http://the/tutorial2/url.com

# TODO: Actually figure out how to explicit the enum from another class (probably named?)
var active_state: UnitStateEnum.VALUES = UnitStateEnum.VALUES.NONE # No init state to keep it explicit
var unit_owner: UnitOwnerEnum.VALUES = UnitOwnerEnum.VALUES.PLAYER
var unit_type

func init(init_owner: UnitOwnerEnum.VALUES, init_type: UnitTypeEnum.VALUES, init_ground_y_position: float):
	unit_owner = init_owner
	unit_type = init_type
	ground_y_position = init_ground_y_position
	$UnitStateWalking.init(init_owner, init_type)
	$UnitStatePluck.init(init_owner, init_type)

## _die()
## Play death animation for unit then clean up memory
func _die():
	queue_free()

## _get_current_position()
##
## Get the current position of object based on the active object
## TODO: I don't think this should apply to this case but special case needs to be made to
## actually set the position on a rigidbody2D after it's been spawned
func _get_current_position() -> Vector2:
	match(active_state):
		UnitStateEnum.VALUES.WALKING:
			return $UnitStateWalking.position
		UnitStateEnum.VALUES.PLUCK:
			return $UnitStatePluck/RigidBody2D.position
	
	push_error("No matching state found!")
	return Vector2(0.0, 0.0) # Should not hit this but just in case
## set_state()
##
## Abstraction layer for setting active unit state
func set_state(state: UnitStateEnum.VALUES, currentPos: Vector2):
	active_state = state
	match(state):
		UnitStateEnum.VALUES.WALKING:
			_set_state_walking(currentPos)
		UnitStateEnum.VALUES.PLUCK:
			_set_state_pluck(currentPos)
			
## call_state()
##
## Abstraction fn for calling a function with args for a unit state
func call_state(state: UnitStateEnum.VALUES, method: String, args: Array):
	match(state):
		UnitStateEnum.VALUES.WALKING:
			$UnitStateWalking.callv(method, args)
		UnitStateEnum.VALUES.PLUCK:
			$UnitStatePluck.callv(method, args)
	
## _hidStates()
## Help fn to hide all states except those in the exception list
##
## exceptions -- State names to exclude in hiding
func _hide_states(exceptions: Dictionary):
	if !exceptions.has(UnitStateEnum.VALUES.WALKING):
		$UnitStateWalking.set_as_inactive_state()
	if !exceptions.has(UnitStateEnum.VALUES.PLUCK):
		$UnitStatePluck.set_as_inactive_state()

func _set_state_walking(current_pos: Vector2):
	_hide_states({ UnitStateEnum.VALUES.WALKING: true })
	var position_to_set = current_pos if current_pos else _get_current_position()
	$UnitStateWalking.set_as_active_state(position_to_set)
	$UnitStateWalking.start_walk()

func _set_state_pluck(current_pos: Vector2):
	_hide_states({ UnitStateEnum.VALUES.PLUCK: true })
	var position_to_set = current_pos if current_pos else _get_current_position()
	$UnitStatePluck.set_as_active_state(position_to_set)


func _on_unit_state_pluck_bounced_twice(globalPosition: Vector2):
	# We only want the x position, course correct so carrot is actually walking on the ground
	set_state(UnitStateEnum.VALUES.WALKING, Vector2(globalPosition.x, ground_y_position))


func _on_unit_state_walking_unit_collision(owned_unit: Area2D, enemy_unit: Area2D):
	_die()
	unit_collide.emit(0) # just emit to score for now
	# TODO: System in place, keep if want to expand on later but for now treat all units as equal
#	var fight_result = UnitTypeEnum.unit_matchup_results(owned_unit.unit_type, enemy_unit.unit_type)
#	if owned_unit.unit_owner == UnitOwnerEnum.VALUES.PLAYER:
#		unit_collide.emit(fight_result)
	# 1 means win, 0 and -1 means die
#	if fight_result < 1:	
#		_die()
