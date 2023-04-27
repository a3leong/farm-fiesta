class_name PlayerResourceLoader

const RESOURCE_PREFIX: String = "res://assets/sprite_frames"

const PATHS = {
	"player": {
		"character": RESOURCE_PREFIX + "/player_character/character/",
		"portrait": RESOURCE_PREFIX + "/player_character/portrait/"
	},
	"unit": {
		"pluck": RESOURCE_PREFIX + "/unit/pluck/",
		"walking": RESOURCE_PREFIX + "/unit/walking/"
	}
}

const SKINS = {
	"farmer": "farmer",
	"racoon": "racoon"
}

# Holds the variables for each possible unit state
var character_skin: String = SKINS.farmer
var character_skin_fn: String = character_skin + ".tres"

# Sprite frames
var sf_player_character: SpriteFrames
var sf_player_portrait: SpriteFrames
var sf_unit_pluck: SpriteFrames
var sf_unit_walking: SpriteFrames

func init(init_skin: String):
	if SKINS.has(init_skin):
		character_skin = init_skin
		character_skin_fn = init_skin + ".tres"
	else:
		# If not found, just remain on the default
		push_error("No skin with name " + init_skin + " found, setting to default")
	loadFrames()

func loadFrames() -> void:
	sf_player_portrait = load(PATHS.player.portrait + character_skin_fn) as SpriteFrames
	sf_player_character = load(PATHS.player.character + character_skin_fn) as SpriteFrames
	sf_unit_pluck = load(PATHS.unit.pluck + character_skin_fn) as SpriteFrames
	sf_unit_pluck = load(PATHS.unit.pluck + character_skin_fn) as SpriteFrames
	sf_unit_walking = load(PATHS.unit.walking + character_skin_fn) as SpriteFrames

func getPlayerCharacterFrames() -> SpriteFrames:
	return sf_player_character
	
func getPlayerPortraitFrames() -> SpriteFrames:
	return sf_player_portrait 

func getUnitPluckFrames() -> SpriteFrames:
	return sf_unit_pluck
	
func getUnitWalkingFrames() -> SpriteFrames:
	return sf_unit_walking
	
## Reads units file and loads into this class file for 1 player.
## For multiple players you will have multiple UnitResources instances
## controlled by a manager

#func load_character(character: PlayerSkinEnum.VALUES):
#	character_skin = _character_enum_to_string(character)
#	var player_resource_object = _loadResourceJSON(character_skin)
#	var character_resource_object = player_resource_object[character_skin]
#	walking_state = player_resource_object.walking_state
#

#func get_sprites(state: UnitStateEnum.VALUES, unit_type: UnitTypeEnum.VALUES) -> SpriteFrames:
#	match state:
#		UnitStateEnum.VALUES.WALKING:
#			var frames: SpriteFrames = load(prefix_folder + "unit_state_walking.tres") as SpriteFrames
#			return frames
#		UnitStateEnum.VALUES.PLUCK:
#			pass
#	push_error("No state match found for getSprites")
#	return SpriteFrames.new() ## Placeholder return for compiling
	
## Only applies to walking state, if we ever get more will need to add a switch/match statement
## to select by scene
#func getCollisionBoundary() -> Vector2:
#	return Vector2(0,0) ## Placeholder return for compiling
#
### TODO: Consider moving this to globals since the file is small and you'd only have to read once in that case
#static func _loadResourceJSON(skin_name: String):
#	var file = FileAccess.open("res://classes/Unit/units.json", FileAccess.READ)
#	var content = file.get_as_text()
#	var playerResourceObj = JSON.parse_string(content)
#	return playerResourceObj[skin_name]

#static func _character_enum_to_string(enum_val: PlayerSkinEnum.VALUES) -> String:
#	match enum_val:
#		PlayerSkinEnum.VALUES.FARMER:
#			return "farmer"
#		PlayerSkinEnum.VALUES.RACOON:
#			return "racoon"
#		_:
#			push_error("No match found for _character_enum_to_string for : " + str(enum_val))
#			return ""

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
