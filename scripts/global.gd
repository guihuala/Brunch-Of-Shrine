extends Node

signal seed_changed(seed)
signal update_station
signal health_change
signal player_die

var player_health:int
var player_health_max:int = 100
var player_is_eat: bool = false
var death_time:int

var delicious: int = 5
var sweetness: int = 4
var salty: int = 3
var sour: int = 1

var spicy: int = 3
var insipid: int = 5
var bitterness: int = 4

func add_health(value):
	player_health += value
	player_health = clamp(player_health, 0, player_health_max)
	emit_signal("health_change")

func sub_health(value):
	if player_health > value:
		player_health -= value
	else:
		player_health = 0
		
		if player_health <= 0:
			emit_signal("player_die")

	emit_signal("health_change")

func check_if_eat():
	if player_is_eat == false:
		sub_health(5)
	player_is_eat = false

func eat_food(food_data):
	add_health(calculate_health(food_data))
	player_is_eat = true

func calculate_health(food_data):
	var health_change = 0
	
	# 计算正面影响
	health_change -= food_data.delicious * delicious
	health_change -= food_data.sweetness * sweetness
	health_change -= food_data.spicy * spicy
	
	# 计算负面影响
	health_change += food_data.insipid * insipid
	health_change += food_data.bitterness * bitterness
	health_change += food_data.sour * sour
	health_change += food_data.salty * salty
	
	# 计算最终结果
	var result = clamp(health_change, -5, 20)
	
	if result > 0:
		result += randi_range(-1, 5)

	return result
