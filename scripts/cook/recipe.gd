extends Resource

class_name Recipe

@export var food_name:String
@export var desc:String
@export var price:int

@export var waste_time:int

@export var Ingredients:Array[PlantData]
@export var result:FoodData

func get_ingredients_list():
	return Ingredients

func get_result():
	return result
