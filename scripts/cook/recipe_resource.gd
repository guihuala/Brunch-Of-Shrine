extends Resource
class_name RecipeResource

@export var recipeList:Array[Recipe]

func get_size():
	return recipeList.size()


func get_recipe_list():
	return recipeList
