@tool
extends Resource
class_name FoodResource

@export var foodList: Array[FoodData] = []
var _food_list: Array[FoodData] = []


func get_size():
	return _food_list.size()

func get_food_list():
	return _food_list

# 序列化方法
func to_dict():
	var food_data_list = []
	for food in _food_list:
		food_data_list.append(food.to_dict())
	return {
		"foodList": food_data_list
	}

# 反序列化方法
static func from_dict(data, original_resource: FoodResource):
	original_resource._food_list.clear()
	
	if data and data.has("foodList"):
		var food_list_data = data.get("foodList", [])
		for food_data in food_list_data:
			original_resource._food_list.append(FoodData.from_dict(food_data))
	else:
		# 如果没有用户数据,使用默认值
		for child in original_resource.foodList:
			original_resource._food_list.append(child)
	
	return original_resource
