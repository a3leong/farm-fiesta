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
var unit_owner: UnitOwnerEnum.VALUES = UnitOwnerEnum.VALUES.PLAYER

######################
# Public Fns
######################
func init(init_owner: UnitOwnerEnum.VALUES):
	unit_owner = init_owner
	if unit_owner == UnitOwnerEnum.VALUES.ENEMY:
		set_process_input(false)

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
func _update_input_tree():
	var current_input_idx = 0
	var children = $CurrentQueue.get_children()


	# Update current queue
	for child in children:
		child.queue_free()
	var is_first = true
	for unit_type in input_queue:
		var new_input_sprite = input_sprite_scene.instantiate()
		match unit_type:
			UnitTypeEnum.VALUES.ROCK:
				new_input_sprite.z()
			UnitTypeEnum.VALUES.PAPER:
				new_input_sprite.x()
			UnitTypeEnum.VALUES.SCISSORS:
				new_input_sprite.c()
			_:
				push_error("No unit type recognized for enum idx: " + str(input_queue))
				return
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
		match unit_type:
			UnitTypeEnum.VALUES.ROCK:
				new_input_sprite.z()
			UnitTypeEnum.VALUES.PAPER:
				new_input_sprite.x()
			UnitTypeEnum.VALUES.SCISSORS:
				new_input_sprite.c()
			_:
				push_error("No unit type recognized for enum idx: " + str(input_queue))
				return
		# All of the next_queue remains opaque
		new_input_sprite.set_modulate(opaque_color)
		$NextQueue.add_child(new_input_sprite)
		
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

######################
# Inherited Fns
######################
func _ready():
	shuffle_inputs()
	shuffle_inputs()

func _input(event: InputEvent):
	var unit_type = null
	if event.is_action_pressed("p1_rock"):
		unit_type = UnitTypeEnum.VALUES.ROCK
	elif event.is_action_pressed("p1_paper"):
		unit_type = UnitTypeEnum.VALUES.PAPER	
	elif event.is_action_pressed("p1_scissors"):
		unit_type = UnitTypeEnum.VALUES.SCISSORS
		
	if unit_type != null:
		if unit_type == input_queue[current_input_idx]:
			_handle_input_success()
			correct_input.emit(unit_type)
		else:
			wrong_input.emit()
	return false
