extends BaseCharacter

var max_favorability:int = 100
var current_favorability:int = 0

@export var reward: Array[PlantData] = []
var current_reward:PlantData

var is_eat:bool = false

var delicious: int = 2
var insipid: int = 5
var sweetness: int = 3
var bitterness: int = 3
var salty: int = 3
var sour: int = 3
var spicy: int = 1

signal save_favorbility()

func init(value):
	current_favorability = value
	current_reward = random_reward()


func random_reward():
	var num = reward.size()
	var index = randi() % num
	
	return reward[index]


func get_current_reward():
	return current_reward


func add_favorbility(value):
	current_favorability = min(current_favorability + value,max_favorability)
	_on_favorbility_changed()


func sub_favorbility(value):
	current_favorability = max(0,current_favorability - value)
	_on_favorbility_changed()


func restart():
	current_favorability = 0
	_on_favorbility_changed()
	current_reward = random_reward()


func _on_favorbility_changed():
	emit_signal("save_favorbility",current_favorability,character_info.character_name)


func calculate_favorability(food_data: FoodData) -> int:
	var favorability_change = 0
	
	# 计算正面影响
	favorability_change -= food_data.delicious * delicious
	favorability_change -= food_data.sweetness * sweetness
	favorability_change -= food_data.spicy * spicy
	
	# 计算负面影响
	favorability_change += food_data.insipid * insipid
	favorability_change += food_data.bitterness * bitterness
	favorability_change += food_data.sour * sour
	favorability_change += food_data.salty * salty
	
	# 计算最终结果
	var result = clamp(favorability_change, -10, 20)
	
	if result > 0:
		result += randi_range(-2, 3)
	
	return result
