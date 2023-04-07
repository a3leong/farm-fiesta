class_name InputUtil

static func get_unit_type_from_input(event: InputEvent) -> UnitTypeEnum.VALUES:
	var unit_type: UnitTypeEnum.VALUES
	if event.is_action_pressed("rock"):
		unit_type = UnitTypeEnum.VALUES.ROCK
	elif event.is_action_pressed("paper"):
		unit_type = UnitTypeEnum.VALUES.PAPER
	elif event.is_action_pressed("scissors"):
		unit_type = UnitTypeEnum.VALUES.SCISSORS
	else:
		push_error("Error occured, unrecognized input for unit spawn")
	return unit_type
