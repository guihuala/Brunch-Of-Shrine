extends Node

var money: int

var plate:int
var plate_dirty:int
var character_favorbility:Dictionary = {}
var season_item_left: Dictionary = {}
var planted_plant: Dictionary = {}

func get_money():
	return money


func add_money(amount:int):
	money += amount


func sub_money(amount:int):
	if money >= amount:
		money -= amount


func add_plate(value):
	plate += value


func use_plate():
	plate_dirty += 1
	plate -= 1


func wash_plate():
	plate_dirty -= 1
	plate += 1


func get_save_data():
	return {
	"money": money,
	"clean_plate": plate,
	"dirty_plate": plate_dirty,
	}


func load_save_data(data):
	money = data.money
	plate = data.clean_plate
	plate_dirty = data.dirty_plate

func load_defult_data():
	money = 10
	plate = 5
	plate_dirty = 5

# 从字典中加载 planted_plant 数据
func planted_plant_from_dict(data: Dictionary):
	for coord_str in data.keys():
		var coord_arr = Array(coord_str.split(","))
		var x = int(coord_arr[0])
		var y = int(coord_arr[1])
		var coord = Vector2i(x,y)
		var plant_data = data[coord_str]
		var plant = Plant.from_dict(plant_data)
		planted_plant[coord] = plant


# 将 planted_plant 字典转换为可序列化的字典
func planted_plant_to_dict() -> Dictionary:
	var planted_plant_dict = {}
	for coord in planted_plant.keys():
		var plant = planted_plant[coord]
		planted_plant_dict[coord] = plant.to_dict()
	return planted_plant_dict
