extends Node

var resource_seed:SeedResource = preload("res://resource/seed_resource.tres")
var resource_plant:PlantResource = preload("res://resource/plant_resource.tres")
var resource_dish:FoodResource = preload("res://resource/food_resource.tres")

const SAVE_DIR = "user://saves/"

func _ready():
	if not DirAccess.dir_exists_absolute(SAVE_DIR):
		DirAccess.make_dir_absolute(SAVE_DIR)

func save_game(date_time):
	var save_data = {
		"time": date_time,
		"seed_resource":resource_seed.to_dict(),
		"food_resource": resource_dish.to_dict(),
		"plant_resource": resource_plant.to_dict(),
		"favorbility": MoneyManager.character_favorbility,
		"commodity": MoneyManager.season_item_left,
		"currency": MoneyManager.get_save_data(),
		"planted_plant":MoneyManager.planted_plant_to_dict(),
		"player_health":Global.player_health,
	}

	var file = FileAccess.open(SAVE_DIR + "save.json", FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(save_data))
		file.close()
	else:
		print("Error: Could not save game")

func load_game():
	var file = FileAccess.open(SAVE_DIR + "save.json", FileAccess.READ)
	if file:
		var json = JSON.new()
		var parse_result = json.parse(file.get_as_text())
		file.close()
		
		if parse_result == OK:
			var save_data = json.get_data()
			resource_seed = SeedResource.from_dict(save_data.seed_resource,resource_seed)
			resource_dish = FoodResource.from_dict(save_data.food_resource,resource_dish)
			resource_plant = PlantResource.from_dict(save_data.plant_resource,resource_plant)
			load_relationships_data(save_data.favorbility)
			load_commodity_data(save_data.commodity)
			MoneyManager.load_save_data(save_data.currency)
			MoneyManager.planted_plant_from_dict(save_data.planted_plant)
			Global.player_health = save_data.player_health
			return save_data
	else:
		resource_seed = SeedResource.from_dict(null,resource_seed)
		resource_dish = FoodResource.from_dict(null,resource_dish)
		resource_plant = PlantResource.from_dict(null,resource_plant)
		MoneyManager.load_defult_data()
		Global.player_health = 100


func delete_save_file():
	var dir = DirAccess.open(SAVE_DIR)
	if dir:
		var err = dir.remove("save.json")
		if err != OK:
			print("Error deleting save file: ", err)

func load_relationships_data(data):
	MoneyManager.character_favorbility = data

func load_commodity_data(data):
	MoneyManager.season_item_left = data
