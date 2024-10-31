extends Resource
class_name FoodData

@export var food_name: String
@export var texture_path: String
@export var price: int
@export var quantity: int

# 食物属性
@export var delicious: int
@export var insipid: int
@export var sweetness: int
@export var bitterness: int
@export var salty: int
@export var sour: int
@export var spicy: int

var texture: Texture

func get_food_name() -> String:
	return food_name

func get_texture() -> Texture:
	if texture == null and texture_path != "":
		texture = load(texture_path)
	return texture

func get_price() -> int:
	return price

func get_quantity() -> int:
	return quantity

# 序列化方法
func to_dict() -> Dictionary:
	return {
		"food_name": food_name,
		"texture_path": texture_path,
		"price": price,
		"quantity": quantity,
		"delicious": delicious,
		"insipid": insipid,
		"sweetness": sweetness,
		"bitterness": bitterness,
		"salty": salty,
		"sour": sour,
		"spicy": spicy
	}

# 反序列化方法
static func from_dict(data: Dictionary) -> FoodData:
	var food_data = FoodData.new()
	food_data.food_name = data.get("food_name", "")
	food_data.texture_path = data.get("texture_path", "")
	food_data.price = data.get("price", 0)
	food_data.quantity = data.get("quantity", 0)
	food_data.delicious = data.get("delicious", 0)
	food_data.insipid = data.get("insipid", 0)
	food_data.sweetness = data.get("sweetness", 0)
	food_data.bitterness = data.get("bitterness", 0)
	food_data.salty = data.get("salty", 0)
	food_data.sour = data.get("sour", 0)
	food_data.spicy = data.get("spicy", 0)
	return food_data

# 设置纹理的方法
func set_texture(tex: Texture) -> void:
	texture = tex
	texture_path = tex.resource_path

# 加载纹理的方法
func load_texture() -> void:
	if texture_path != "":
		texture = load(texture_path)
