extends Node

class_name TimeSystem

@export var date_time:DateTime
@export var ticks_pr_second:int =288
@export var crop_area_start: Vector2i = Vector2i(-1000, -1000)
@export var crop_area_end: Vector2i = Vector2i(1000, 1000)
@export var collection:PackedScene

@onready var character_generate = $"../world/character"
@onready var trigger = $"../trigger"
@onready var hud = $"../HUD"


const season_texture =[
	preload("res://assets/TileSheet/tileset.png"),
]

var crops: Dictionary = {}

@onready var tilemap = $".."
@onready var crops_layer = $"../world/crops"


func _ready():
	load_time()
	date_time.season_changed.connect(_on_season_changed)
	date_time.morning_coming.connect(_on_morning_coming)
	date_time.day_over.connect(_on_day_over)
	date_time.week_changed.connect(_on_week_changed)
	
	_on_week_changed(0)
	_on_season_changed(date_time.get_current_season())

func _process(delta:float):
	date_time.increase_by_sec(delta * ticks_pr_second)

func format_time(time: DateTime):
	return str(time.days) + ":" + str(time.hours) + ":" + str(time.minutes)

#每日早更新的事件
func _on_morning_coming():
	character_generate.init()
	trigger._create_new_region()
	hud.update_stall_daily()
	if date_time.days != 1:
		save_game()

#每日晚移除更新事件
func _on_day_over():
	character_generate.over()
	trigger.remove_region()
	Global.check_if_eat()
	hud.update_healthy_bar()

#每周更新事件
func _on_week_changed(new_week: int):
	var season_index = new_week / 3
	if season_index == 0:
		generate_crops("Spring")
	elif season_index == 1:
		generate_crops("Summer")
	elif season_index == 2:
		generate_crops("Fall")
	else :
		generate_crops("Winter")

# 季节变更
func _on_season_changed(new_season: String):
	match new_season:
		"Spring":
			_spring_event()
		"Summer":
			_summer_event()
		"Fall":
			_fall_event()
		"Winter":
			_winter_event()
	hud.update_stall_per_season()


func _spring_event():
	hud.current_season = "Spring"
	tilemap.tile_set.get_source(0).texture = season_texture[0]


func _summer_event():
	hud.current_season = "Summer"
	tilemap.tile_set.get_source(0).texture = season_texture[0]


func _fall_event():
	hud.current_season = "Fall"
	tilemap.tile_set.get_source(0).texture = season_texture[0]


func _winter_event():
	hud.current_season = "Winter"
	tilemap.tile_set.get_source(0).texture = season_texture[0]


func generate_crops(season: String):
	for child in crops_layer.get_children():
		child.queue_free()
	crops.clear()

	var num_crops = randi() % 2 + 4
	for i in range(num_crops):
		var random_x = randi() % (crop_area_end.x - crop_area_start.x) + crop_area_start.x
		var random_y = randi() % (crop_area_end.y - crop_area_start.y) + crop_area_start.y
		var cell_pos = Vector2i(random_x, random_y)
		
		if tilemap.get_cell_source_id(5, cell_pos,false) == -1 and not crops.has(cell_pos):
			var collection_instance = collection.instantiate()
			collection_instance.global_position = tilemap.local_to_map(cell_pos)
			
			crops[cell_pos] = collection_instance
			crops_layer.add_child(collection_instance)
			collection_instance.init(season)


func save_game():
	SaveManager.save_game(date_time.to_dict())

func load_time():
	var save_data = SaveManager.load_game()
	if save_data and save_data.has("time"):
		date_time = DateTime.from_dict(save_data.time)
	else :
		date_time = DateTime.load_default_time_data()
	
	play_anim()

func skip_to_next_morning():
	date_time.set_to_morning()
	print(format_time(date_time))
	play_anim()

func play_anim():
	$AnimationPlayer.seek(72)
	$AnimationPlayer.play("time_system")
