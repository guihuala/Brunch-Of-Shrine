extends Node2D
class_name Plant

@export var amount: int = 2
@export var plantItem: PlantData
@export var harvest_ready: bool = false

var index = 0

func _ready():
	$AnimationPlayer.play(str(index))


func _on_timer_timeout():
	index += 1
	$AnimationPlayer.play(str(index))

func harvest():
	var plant_data = preload("res://resource/plant_resource.tres")
	for child in plant_data.get_plant_list():
		if plantItem.get_plant_name() == child.get_plant_name():
			child.quantity += amount
	queue_free()

# 序列化方法
func to_dict() -> Dictionary:
	return {
		"amount": amount,
		"plantItem": plantItem.to_dict(),
		"harvest_ready": harvest_ready,
		"index": index
	}

# 反序列化方法
static func from_dict(data: Dictionary) -> Plant:
	var plant_info = PlantData.from_dict(data.plantItem)
	var plant = get_instance_by_name(plant_info)
	var plant_instance = plant.instantiate()
	
	plant_instance.amount = data.get("amount", 2)
	plant_instance.plantItem = PlantData.from_dict(data.plantItem)
	plant_instance.harvest_ready = data.get("harvest_ready", false)
	plant_instance.index = data.get("index", 0)
	
	
	return plant_instance

static func get_instance_by_name(data):
	var name = data.get_plant_name()
	
	var seed_data = preload("res://resource/seed_resource.tres")
	for child in seed_data.get_seed_list():
		if name == child.get_seed_name():
			return child.plantSence
