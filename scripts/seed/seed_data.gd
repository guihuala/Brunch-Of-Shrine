extends Resource
class_name SeedData

signal quantity_changed(new_quantity)

@export var plantDataResource: PlantData
@export var plantSence: PackedScene
@export var price: int


func seed_left():
	return plantDataResource.quantity > 0

func add_quantity(value):
	plantDataResource.quantity  += value

func sub_quantity():
	if seed_left():
		plantDataResource.quantity  -= 1
	quantity_changed.emit(plantDataResource.quantity )

func get_texture():
	return plantDataResource.get_texture()

func get_quantity():
	return plantDataResource.quantity 

func get_seed_name():
	return plantDataResource.get_plant_name()

func get_price():
	return price


func to_dict() -> Dictionary:
	return {
		"plant_data": plantDataResource.to_dict(),
		"plant_scene": plantSence.resource_path,
		"price": price,
		"quantity": plantDataResource.quantity 
	}


static func from_dict(data: Dictionary) -> SeedData:
	var seed_data = SeedData.new()
	seed_data.plantDataResource = PlantData.from_dict(data.plant_data)
	seed_data.plantSence = load(data.plant_scene) as PackedScene
	seed_data.price = data.get("price", 0)
	seed_data.plantDataResource.quantity = data.get("quantity", 0)
	return seed_data
