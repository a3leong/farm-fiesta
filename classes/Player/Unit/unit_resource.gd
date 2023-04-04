class_name UnitResource

enum CHARACTERS {
	FARMER
}

# Holds the variables for each possible unit state
var character_name: String
var walking_state: Object
var pluck_state: Object

## Reads units file and loads into this class file for 1 player.
## For multiple players you will have multiple UnitResources instances
## controlled by a manager

func loadCharacter(character: CHARACTERS):
	character_name = _character_enum_to_string(character)
	var player_resource_object = _loadResourceJSON()
	var character_resource_object = player_resource_object[character_name]
	walking_state = player_resource_object.walking_state
	

func getSprites(state: UnitStateEnum.VALUES, unit_type: UnitTypeEnum.VALUES) -> SpriteFrames:
	var prefix_folder = "res://assets/sprite_frames/" + character_name
	match state:
		UnitStateEnum.VALUES.WALKING:
			var frames: SpriteFrames = load(prefix_folder + "unit_state_walking.tres") as SpriteFrames
			return frames
		UnitStateEnum.VALUES.PLUCK:
			pass
	push_error("No state match found for getSprites")
	return SpriteFrames.new() ## Placeholder return for compiling
	
## Only applies to walking state, if we ever get more will need to add a switch/match statement
## to select by scene
func getCollisionBoundary() -> Vector2:
	return Vector2(0,0) ## Placeholder return for compiling

## TODO: Consider moving this to globals since the file is small and you'd only have to read once in that case
func _loadResourceJSON():
	var file = FileAccess.open("res://classes/Unit/units.json", FileAccess.READ)
	var content = file.get_as_text()
	var playerResourceObj = JSON.parse_string(content)
	return playerResourceObj

func _character_enum_to_string(enum_val: CHARACTERS) -> String:
	match enum_val:
		CHARACTERS.FARMER:
			return "farmer"
	
	push_error("No match found for _character_enum_to_string")
	return "" # Error

#{
#	"farmer": {
#		"walking_state": {
#			"sprite": "res://assets/sprite_frames/farmer/unit_state_walking.tres",
#			"collision": {
#				"rock": [11,14],
#				"paper": [20,17],
#				"scissors": [12,24]
#			}
#		},
#		"walking_state": {
#			"sprite": "res://assets/sprite_frames/farmer/unit_state_walking.tres",
#			"collision": {
#				"rock": [11,14],
#				"paper": [20,17],
#				"scissors": [12,24]
#			}
#		}
#	}
#}
