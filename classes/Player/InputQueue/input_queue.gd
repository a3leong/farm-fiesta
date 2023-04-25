extends VBoxContainer
@export var input_sprite_scene: PackedScene
@export var max_inputs: int = 6
@export var opaque_color = Color("ffffff64")
@export var full_color = Color("ffffff")

signal correct_input
signal wrong_input

var input_queue: Array[UnitTypeEnum.VALUES] = []
var next_queue: Array[UnitTypeEnum.VALUES] = []
var current_input_idx = 0
var unit_owner: UnitOwnerEnum.VALUES = UnitOwnerEnum.VALUES.PLAYER1

######################
# Public Fns
######################
func init(init_owner: UnitOwnerEnum.VALUES):
	unit_owner = init_owner
	if unit_owner == UnitOwnerEnum.VALUES.PLAYER2: # Input disable by enemy is handled by parent node
		var old_scale = get_scale()
		set_scale(Vector2(-old_scale.x, old_scale.y))
	_ready() # Call ready again after to reset the inputs since this goes after ready

# Reset idx and get new input list
func shuffle_inputs():
	current_input_idx = 0
	var new_inputs: Array[UnitTypeEnum.VALUES] = []
	for idx in range(max_inputs):
		new_inputs.push_back(UnitTypeEnum.VALUES.values()[randi() % UnitTypeEnum.VALUES.size()])
	input_queue = next_queue
	next_queue = new_inputs
	_update_input_tree()

######################
# Private Fns
######################
func _handle_input_success():
	current_input_idx += 1
	if current_input_idx == max_inputs:
		shuffle_inputs()
	else:
		# Set previous to lower modulate
		var prev_node: InputSprite = $CurrentQueue.get_child(current_input_idx-1) as InputSprite
		var cn: InputSprite = $CurrentQueue.get_child(current_input_idx) as InputSprite 
		prev_node.set_modulate(opaque_color)
		cn.set_modulate(full_color) # Full color

func _set_input_sprite(unit_type: UnitTypeEnum.VALUES, new_input_sprite: InputSprite):
	match unit_type:
		UnitTypeEnum.VALUES.ROCK:
			new_input_sprite.left()
#			if unit_owner == UnitOwnerEnum.VALUES.PLAYER2:
#				new_input_sprite.left()
#			else:
#				new_input_sprite.z()
		UnitTypeEnum.VALUES.PAPER:
			new_input_sprite.middle()
#			if unit_owner == UnitOwnerEnum.VALUES.PLAYER2:
#				new_input_sprite.down()
#			else:
#				new_input_sprite.x()
		UnitTypeEnum.VALUES.SCISSORS:
			new_input_sprite.right()
#			if unit_owner == UnitOwnerEnum.VALUES.PLAYER2:
#				new_input_sprite.right()
#			else:
#				new_input_sprite.c()
		_:
			push_error("No unit type recognized for enum idx: " + str(input_queue))
			new_input_sprite.none()

func _update_input_tree():
	var children = $CurrentQueue.get_children()

	# Update current queue
	for child in children:
		child.queue_free()
	var is_first = true
	for unit_type in input_queue:
		var new_input_sprite = input_sprite_scene.instantiate()
		_set_input_sprite(unit_type, new_input_sprite)
		if is_first:
			new_input_sprite.set_modulate(full_color)
			is_first = false
		else:
			new_input_sprite.set_modulate(opaque_color)
		$CurrentQueue.add_child(new_input_sprite)
		
	# Update next queue
	children = $NextQueue.get_children()
	for child in children:
		child.queue_free()
	for unit_type in next_queue:
		var new_input_sprite = input_sprite_scene.instantiate()
		_set_input_sprite(unit_type, new_input_sprite)
		# All of the next_queue remains opaque
		new_input_sprite.set_modulate(opaque_color)
		$NextQueue.add_child(new_input_sprite)


######################
# Inherited Fns
######################
func _ready():
	shuffle_inputs()
	shuffle_inputs()

func _input(event: InputEvent):
	# TODO Only read rps inputs depending on player so other players on the same keyboard don't interfere
	var unit_type = null
	
	if unit_owner == UnitOwnerEnum.VALUES.PLAYER1:
		if event.is_action_pressed("p1_rock"):
			unit_type = UnitTypeEnum.VALUES.ROCK
		elif event.is_action_pressed("p1_paper"):
			unit_type = UnitTypeEnum.VALUES.PAPER	
		elif event.is_action_pressed("p1_scissors"):
			unit_type = UnitTypeEnum.VALUES.SCISSORS
	elif unit_owner == UnitOwnerEnum.VALUES.PLAYER2:
		if event.is_action_pressed("p2_rock"):
			unit_type = UnitTypeEnum.VALUES.ROCK
		elif event.is_action_pressed("p2_paper"):
			unit_type = UnitTypeEnum.VALUES.PAPER	
		elif event.is_action_pressed("p2_scissors"):
			unit_type = UnitTypeEnum.VALUES.SCISSORS

	if unit_type != null:
		if unit_type == input_queue[current_input_idx]:
			_handle_input_success()
			correct_input.emit(unit_type)
		else:
			wrong_input.emit()
