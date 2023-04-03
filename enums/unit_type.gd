class_name UnitTypeEnum

enum VALUES {
	ROCK,
	PAPER,
	SCISSORS
}

# Returns -1 if unit loses to
# Returns 0 if unit is even
# Returns 1 if unit beats other unit
# This logic only accounts for RPS, if you add more complexity update this fn
static func unit_matchup_results(u1_type, u2_type) -> int:
	if u1_type == u2_type:
		return 0
	
	var return_value = -2
	
	if u1_type == VALUES.ROCK:
		return_value =  1 if u2_type == VALUES.SCISSORS else -1
	if u1_type == VALUES.PAPER:
		return_value = 1 if u2_type == VALUES.ROCK else -1
	if u1_type == VALUES.SCISSORS:
		return_value =  1 if u2_type == VALUES.PAPER else -1
	
	return return_value
