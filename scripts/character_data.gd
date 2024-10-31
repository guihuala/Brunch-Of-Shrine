extends Resource
class_name CharacterData

@export var character_name:String
@export var character_texture:Texture
@export var character_salutation:Array[String]
@export var quest:Array[QuestData]
@export var isNPC:bool

func get_character_name():
	return character_name

func get_character_texture():
	return character_texture

func get_character_salutation():
	return character_salutation

func get_character_salutation_size():
	return character_salutation.size()

func get_quest():
	return quest

func get_quest_size():
	return quest.size()
