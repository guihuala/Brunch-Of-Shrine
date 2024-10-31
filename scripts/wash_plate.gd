extends Control

enum Mode { ADD_FOAM, REMOVE_FOAM, NONE }
var current_mode
var last_mouse_position = null
var is_in_area = false

@onready var viewport = $NinePatchRect
@onready var foam_viewport = $NinePatchRect/FoamTextureRect
@onready var detergent_button = $NinePatchRect/detergent_button
@onready var water_button = $NinePatchRect/water_button

@export var bubble_sprite: PackedScene
@export var foam_generation_interval: float = 0.1  # 泡沫生成间隔（秒）
@export var grid_size: int = 20  # 网格大小
@export var coverage_check_interval: float = 0.2  # 覆盖检查间隔（秒）

var foam_generation_timer: float = 0.0
var coverage_check_timer: float = 0.0

var grid: Dictionary = {}
var total_grids: int = 0
var covered_grids: int = 0

func init():
	current_mode = Mode.NONE
	var area_width = foam_viewport.size.x
	var area_height = foam_viewport.size.y
	total_grids = int((area_width / grid_size) * (area_height / grid_size))
	update_plate_label()

func _process(delta):
	foam_generation_timer += delta
	coverage_check_timer += delta
	
	if coverage_check_timer >= coverage_check_interval:
		check_coverage()
		coverage_check_timer = 0.0

func _input(event):
	if event is InputEventMouseMotion and is_in_area:
		var local_pos = event.position - foam_viewport.position - viewport.position - $".".position
		if current_mode == Mode.ADD_FOAM and foam_generation_timer >= foam_generation_interval:
			add_foam(local_pos)
			foam_generation_timer = 0.0
			update_covered_area(local_pos)
		elif current_mode == Mode.REMOVE_FOAM:
			remove_foam(local_pos)


func add_foam(pos):
	if foam_viewport.get_children().size() <= 80:
		var foam_sprite = bubble_sprite.instantiate()
		foam_sprite.position = pos
		foam_viewport.add_child(foam_sprite)

func remove_foam(pos):
	var foam_sprites = foam_viewport.get_children()
	for sprite in foam_sprites:
		if sprite is Sprite2D and sprite.position.distance_to(pos) < 50:
			sprite.queue_free()

func update_covered_area(pos):
	var grid_x = int(pos.x / grid_size)
	var grid_y = int(pos.y / grid_size)
	
	for x in range(grid_x - 1, grid_x + 2):
		for y in range(grid_y - 1, grid_y + 2):
			var grid_pos = Vector2(x, y)
			if !grid.has(grid_pos):
				grid[grid_pos] = true
				covered_grids += 1

func check_coverage():
	var coverage_percentage = (float(covered_grids) / float(total_grids)) * 100
	if coverage_percentage > 90:
		if foam_viewport.get_children().size() <= 2:

			MoneyManager.wash_plate()
			update_plate_label()
			reset_coverage()

func reset_coverage():
	grid.clear()
	covered_grids = 0

func update_plate_label():
	var label = $NinePatchRect/Label
	label.text = "plate:" + str(MoneyManager.plate) + "\ndirty:" + str(MoneyManager.plate_dirty)

func _on_water_button_button_down():
	current_mode = Mode.REMOVE_FOAM

func _on_detergent_button_button_down():
	current_mode = Mode.ADD_FOAM

func _on_area_2d_mouse_entered():
	is_in_area = true

func _on_area_2d_mouse_exited():
	is_in_area = false
