extends Resource
class_name QuestData

@export var name:String
@export var reward:Resource
@export var reward_amount:int
@export var require:Array[Resource]
@export var desc:String

func get_quest_name():
	return name

func get_reward():
	return reward

func get_reward_amount():
	return reward_amount

func get_require():
	return require

func get_desc():
	return desc
