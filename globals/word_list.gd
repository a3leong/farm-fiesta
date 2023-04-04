extends Node

var word_array: Array[String] = []
var word_list_size = 0 # Is actually the size-1 because 0 index and this is used for access

func _init():
	_load_words()
	
func _load_words() -> void:
	var file = FileAccess.open("res://assets/dictionary/word_list.txt", FileAccess.READ)
	var word_line
	
	# We won't parse any of that data but instead do it on demand and let the calling class handle it
	while true:
		word_line = file.get_line()
		word_array.push_back(word_line)
		word_list_size += 1
		if file.eof_reached():
			break
	
# Pulls a random word from the dictionary and returns it 
func get_word() -> String:
	# TODO: Remove this once we make sure there's no race condition here
	if word_list_size == 0:
		return "error"
	var random_index = randi() % word_list_size # Returns 0-(N-1) so we're ok on index
	print(word_array[random_index])
	return word_array[random_index]
	
