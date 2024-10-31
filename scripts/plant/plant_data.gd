extends Resource
class_name PlantData

@export var plant_name_resource: PlantName
@export var desc: String
@export var price: int
@export var texture_path: String
@export var quantity: int

var texture: Texture

func get_plant_name():
	return plant_name_resource.plant_name

func get_plant_desc():
	return desc

func get_price():
	return price

func get_texture() -> Texture:
	if texture == null and texture_path != "":
		texture = load(texture_path)
	return texture

func get_quantity():
	return quantity

# 序列化方法
func to_dict() -> Dictionary:
	return {
		"plant_name": plant_name_resource.plant_name,
		"desc": desc,
		"price": price,
		"texture_path": texture_path,
		"quantity": quantity
	}

# 反序列化方法
static func from_dict(data: Dictionary) -> PlantData:
	var plant_data = PlantData.new()
	plant_data.plant_name_resource = PlantName.new()
	plant_data.plant_name_resource.plant_name = data.get("plant_name", "")
	plant_data.desc = data.get("desc", "")
	plant_data.price = data.get("price", 0)
	plant_data.texture_path = data.get("texture_path", "")
	plant_data.quantity = data.get("quantity", 0)
	return plant_data
