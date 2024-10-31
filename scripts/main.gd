extends TileMap

@onready var grid_helper = $world/GridHelper
@onready var player = $world/player

var current_seed: SeedData

func _ready():
	if MoneyManager.planted_plant:
		instantiate_plants_from_dict()
	Global.seed_changed.connect(_on_seed_changed)
	$HUD.setup_inventory()

func instantiate_plants_from_dict():
	var plant_data_dict = MoneyManager.planted_plant

	for coord in plant_data_dict.keys():
		var plant_data = plant_data_dict[coord]
		get_node("world/plant").add_child(plant_data)
		plant_data.global_position = map_to_local(coord)

func _physics_process(_delta):
	var playerMapPosition = local_to_map(player.global_position)
	var playerDir = player.up_direction
	var playerMap = playerMapPosition + Vector2i(playerDir) / 32
	grid_helper.global_position = playerMapPosition * 16

	check_and_update_mouse_icon(playerMapPosition)

func _on_player_plant():
	var cellLocalCoord = local_to_map(grid_helper.position)
	var tile: TileData = get_cell_tile_data(1, cellLocalCoord)

	if tile == null or current_seed == null:
		return

	if tile.get_custom_data("garden"):
		if not MoneyManager.planted_plant.has(cellLocalCoord):
			if current_seed.seed_left():
				current_seed.sub_quantity()
				plant_seed(cellLocalCoord)
			else:
				$HUD.inventory_slot_empty(current_seed)


func _on_player_harvest():
	var cellLocalCoord = local_to_map(grid_helper.position)
	if is_harvestable(cellLocalCoord):
		harvest_plant(cellLocalCoord)


func _on_player_hoeing():
	var cellLocalCoord = local_to_map(grid_helper.position)
	if MoneyManager.planted_plant.has(cellLocalCoord):
		var plant = MoneyManager.planted_plant.get(cellLocalCoord)
		plant.queue_free()
		MoneyManager.planted_plant.erase(cellLocalCoord)


func plant_seed(coord):
	var plant = current_seed.plantSence.instantiate()
	get_node("world/plant").add_child(plant)

	MoneyManager.planted_plant[coord] = plant
	plant.global_position = map_to_local(coord)

func is_harvestable(key):
	var data = MoneyManager.planted_plant.get(key)
	return data.harvest_ready if data != null else false

func harvest_plant(key):
	var plant: Plant = MoneyManager.planted_plant.get(key)
	if plant.has_method("harvest"):
		plant.harvest()
		MoneyManager.planted_plant.erase(key)

func _on_seed_changed(new_seed):
	current_seed = new_seed

func check_and_update_mouse_icon(playerMapPosition):
	if is_harvestable(playerMapPosition):
		MouseController.player_in_harvest_area = true
		MouseController.change_mouse()
	else:
		MouseController.player_in_harvest_area = false
		MouseController.change_mouse()



