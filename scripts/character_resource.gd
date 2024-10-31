extends Resource
class_name CharacterResource

@export var character_list:Array[PackedScene]

func get_character_list():
	return character_list

func get_character_list_size():
	return character_list.size()
