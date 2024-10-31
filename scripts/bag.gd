extends Control

@export var slotScene:PackedScene

@export var seedsResource: SeedResource
@export var plantsResource: PlantResource
@export var foodsResource: FoodResource

@onready var tooltip = $tooltip
@onready var grid_container = $NinePatchRect/MarginContainer/ScrollContainer/GridContainer


func _on_tab_bar_tab_changed(tab):
	clear_items_in_container()
	inventory_update_container(tab)


func inventory_update_container(tab):
	match tab:
		0:
			add_new_slot(seedsResource.get_seed_list())
		1:
			add_new_slot(foodsResource.get_food_list())
		2:
			add_new_slot(plantsResource.get_plant_list())


func clear_items_in_container():
	var children = $NinePatchRect/MarginContainer/ScrollContainer/GridContainer.get_children()
	for child in children:
		child.queue_free()

#初始化背包
func init():
	$TabBar.set_current_tab(0)
	_on_tab_bar_tab_changed(0)
	update_money()


func update_money():
	$NinePatchRect/Label.text = "money:" + str(MoneyManager.money)
	
	
#增加物品格子
func add_new_slot(array:Array):
	for child in array:
		instance_slot(child)


#实例化物品格子
func instance_slot(itemData):
	if itemData.get_quantity() > 0:
		var slot = slotScene.instantiate()
		grid_container.add_child(slot)
		slot.set_item_info(itemData.get_texture(),itemData.get_quantity())
		slot.connect("gui_input",_on_slot_gui_input.bind(itemData))


func show_tooltip(item_data):
	tooltip.visible = true

	
	if item_data is FoodData:
		tooltip.init(item_data,item_data.get_food_name(), null,item_data.get_price(),item_data.get_quantity())
	elif item_data is SeedData:
		tooltip.init(item_data,item_data.get_seed_name(), null,item_data.get_price(),item_data.get_quantity())
	elif item_data is PlantData:
		tooltip.init(item_data,item_data.get_plant_name(),item_data.get_plant_desc(),item_data.get_price(),item_data.get_quantity())

	var mouse_pos = get_viewport().get_mouse_position()
	
	var new_position_x = mouse_pos.x - 270
	var new_position_y = mouse_pos.y - 160

	# 设置面板位置
	tooltip.position = Vector2(new_position_x, new_position_y)

func hide_tooltip():
	tooltip.visible = false


func _on_slot_gui_input(event, item_data):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			show_tooltip(item_data)


func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if tooltip.visible and not is_inside_tooltip(event.position):
				hide_tooltip()

func is_inside_tooltip(global_position: Vector2):
	var tooltip_rect = Rect2(tooltip.global_position, tooltip.size)
	return tooltip_rect.has_point(global_position)
