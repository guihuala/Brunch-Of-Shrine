@tool
extends Resource
class_name SeedResource

@export var seedList: Array[SeedData] = []
var _seed_list: Array[SeedData] = []


func get_seed_data(value):
	for child in seedList:
		if child.get_seed_name() == value:
			return child
	return null

func get_size():
	return _seed_list.size()

func get_seed_list():
	return _seed_list

# 序列化方法
func to_dict():
	var seed_data_list = []
	for seed in _seed_list:
		seed_data_list.append(seed.to_dict())
	return {
		"seedList": seed_data_list
	}

# 反序列化方法
static func from_dict(data, original_resource: SeedResource):
	original_resource._seed_list.clear()
	
	if data and data.has("seedList"):
		var seed_list_data = data.get("seedList", [])
		for seed_data in seed_list_data:
			original_resource._seed_list.append(SeedData.from_dict(seed_data))
	else:
		for child in original_resource.seedList:
			original_resource._seed_list.append(child)

	return original_resource
