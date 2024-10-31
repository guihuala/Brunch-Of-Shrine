@tool
extends Resource
class_name PlantResource

@export var plantList: Array[PlantData] = []
var _plant_list: Array[PlantData] = []


func get_season_size():
	return plantList.size()

func get_season_list():
	return plantList

func get_size():
	return _plant_list.size()

func get_plant_list():
	return _plant_list

func to_dict():
	var plant_data_list = []
	for plant in _plant_list:
		plant_data_list.append(plant.to_dict())
	return {
		"plantList": plant_data_list
	}

static func from_dict(data, original_resource: PlantResource):
	original_resource._plant_list.clear()
	
	if data and data.has("plantList"):
		var plant_list_data = data.get("plantList", [])
		for plant_data in plant_list_data:
			original_resource._plant_list.append(PlantData.from_dict(plant_data))
	else:
		# 如果没有用户数据,使用默认值
		for child in original_resource.plantList:
			original_resource._plant_list.append(child)
	
	return original_resource
