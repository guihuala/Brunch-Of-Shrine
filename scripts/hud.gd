extends CanvasLayer

@export var player:CharacterBody2D

@onready var shop = $shop
@onready var kitchen = $kitchen
@onready var bag = $bag
@onready var character_quest = $character_info
@onready var stall = $stall
@onready var plate = $wash_plate
@onready var settings_menu = $setting

@onready var minimap = $minimap
@onready var button = $TextureButton
@onready var healthybar = $TextureButton/healthyBar
@onready var inventory = $inventory

@onready var screenSize = get_viewport().get_visible_rect().size
@onready var trigger_area = $"../trigger"
@onready var character_layer = $"../world/character"

var inventory_hidden:bool = false
var minimap_hidden:bool = true
var is_paused = false

var current_season:String

func _ready():
	minimap.player = player
	update_healthy_bar()
	Global.health_change.connect(update_healthy_bar)


func _input(event:InputEvent):
	if event.is_action_pressed("pause"):
		toggle_pause()

	if is_paused:
		return

	if event.is_action_pressed("Inventory") and check_if_windows_closed():
		inventory_hidden = not inventory_hidden
		toggle_inventory_ui()

	if event.is_action_pressed("map") and check_if_windows_closed():
		minimap_hidden = not minimap_hidden
		toggle_map_ui()



	if Input.is_action_just_pressed("open_window") and not bag.visible:
		# 检查商店窗口
		if trigger_area.player_in_area_shop:
			if not shop.visible:
				open_shop_window()
			else:
				close_shop_window()

		# 检查厨房窗口
		if trigger_area.player_in_area_kitchen:
			if not kitchen.visible:
				open_kitchen_window()
			else:
				close_kitchen_window()
		
		if character_layer.current_character:
			if not character_quest.visible:
				open_character_window()
			else:
				close_character_window()
		
		if trigger_area.player_in_area_stall:
			if not stall.visible:
				open_stall_window()
			else:
				close_stall_window()
		
		if trigger_area.player_in_plate_area:
			if not plate.visible:
				open_plate_window()
			else :
				close_plate_window()
	
	inventory.update_inventory()


	if not trigger_area.player_in_area_kitchen and kitchen.visible:
		close_kitchen_window()

	if not trigger_area.player_in_area_shop and shop.visible:
		close_shop_window()
	
	if not character_layer.current_character and character_quest.visible:
		close_character_window()
	
	if not trigger_area.player_in_area_stall and stall.visible:
		close_stall_window()
	
	if not trigger_area.player_in_plate_area and plate.visible:
		close_plate_window()


func check_if_windows_closed():
	if not shop.visible and not kitchen.visible and not character_quest.visible and not bag.visible and not stall.visible and not plate.visible:
		return true
	else :
		return false


func toggle_pause():
	is_paused = !is_paused
	get_tree().paused = is_paused
	if is_paused:

		settings_menu.show()
	else:
		settings_menu.resume_game()
		settings_menu.hide()


#隐藏背包栏
func toggle_inventory_ui():
	create_tween().set_ease(Tween.EASE_IN_OUT).tween_property(
		inventory,"position:y",
		screenSize.y + inventory.size.y if inventory_hidden else screenSize.y - inventory.size.y,
		0.5)


func toggle_map_ui():
	create_tween().set_ease(Tween.EASE_IN_OUT).tween_property(
		minimap,"position:y",
		-86 if minimap_hidden else 0,
		0.3)


#初始化工具栏
func setup_inventory():
	inventory.init()

func inventory_slot_empty(seed):
	inventory.is_slot_empty(seed)

func update_inventory_ui(value):
	inventory.visible = not value
	minimap.visible = not value

#更新商店ui
func update_shop_ui(value):
	shop.visible = value
	$TextureButton.visible = not value
	update_inventory_ui(value)

#打开商店ui
func open_shop_window():
	MouseController.is_window_open = true
	MouseController.change_mouse()
	
	Global.update_station.emit()
	shop.get_node("NinePatchRect/MarginContainer/ScrollContainer/stationContainer").update_plant_seed_quantity()
	shop.scale = Vector2.ZERO
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_callback(update_shop_ui.bind(true))
	tween.tween_property(shop,"scale",Vector2(1,1),0.25)

#关闭商店ui
func close_shop_window():
	MouseController.is_window_open = false
	MouseController.change_mouse()
	
	inventory.update_inventory()
	var tween = create_tween().set_ease(Tween.EASE_OUT)
	tween.tween_property(shop,"scale",Vector2.ZERO,0.25)
	tween.tween_callback(update_shop_ui.bind(false))

#更新厨房ui
func update_kitchen_ui(value):
	kitchen.visible = value
	$TextureButton.visible = not value
	update_inventory_ui(value)

#打开厨房ui
func open_kitchen_window():
	MouseController.is_window_open = true
	MouseController.change_mouse()
	
	kitchen.init()
	kitchen.scale = Vector2.ZERO
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_callback(update_kitchen_ui.bind(true))
	tween.tween_property(kitchen,"scale",Vector2(1,1),0.25)

#关闭厨房ui
func close_kitchen_window():
	MouseController.is_window_open = false
	MouseController.change_mouse()
	
	kitchen.window_is_open = false
	var tween = create_tween().set_ease(Tween.EASE_OUT)
	tween.tween_property(kitchen,"scale",Vector2.ZERO,0.25)
	tween.tween_callback(update_kitchen_ui.bind(false))

#更新背包ui
func update_bag_ui(value):
	bag.visible = value
	update_inventory_ui(value)

#打开背包ui
func open_bag_window():
	MouseController.is_window_open = true
	MouseController.change_mouse()
	
	bag.init()
	bag.scale = Vector2.ZERO
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_callback(update_bag_ui.bind(true))
	tween.tween_property(bag,"scale",Vector2(1,1),0.25)

#关闭背包ui
func close_bag_window():
	MouseController.is_window_open = false
	
	var tween = create_tween().set_ease(Tween.EASE_OUT)
	tween.tween_property(bag,"scale",Vector2.ZERO,0.25)
	tween.tween_callback(update_bag_ui.bind(false))

#更新角色ui
func update_character_ui(value):
	character_quest.visible = value
	$TextureButton.visible = not value
	update_inventory_ui(value)

#打开角色ui
func open_character_window():
	MouseController.is_window_open = true
	MouseController.change_mouse()
	
	character_quest.init(character_layer.current_character,character_layer.character_dictionary.get(character_layer.current_character.character_info.character_name))
	character_quest.scale = Vector2.ZERO
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_callback(update_character_ui.bind(true))
	tween.tween_property(character_quest,"scale",Vector2(1,1),0.25)

#关闭角色ui
func close_character_window():
	MouseController.is_window_open = false
	MouseController.change_mouse()
	
	var tween = create_tween().set_ease(Tween.EASE_OUT)
	tween.tween_property(character_quest,"scale",Vector2.ZERO,0.25)
	tween.tween_callback(update_character_ui.bind(false))

#更新小卖铺ui
func update_stall_ui(value):
	stall.visible = value
	$TextureButton.visible = not value
	update_inventory_ui(value)

#打开小卖铺ui
func open_stall_window():
	MouseController.is_window_open = true
	MouseController.change_mouse()
	
	stall.init()
	stall.scale = Vector2.ZERO
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_callback(update_stall_ui.bind(true))
	tween.tween_property(stall,"scale",Vector2(1,1),0.25)

#关闭小卖铺ui
func close_stall_window():
	MouseController.is_window_open = false
	MouseController.change_mouse()
	
	var tween = create_tween().set_ease(Tween.EASE_OUT)
	tween.tween_property(stall,"scale",Vector2.ZERO,0.25)
	tween.tween_callback(update_stall_ui.bind(false))

func update_stall_per_season():
	stall._update_current_item_perseason(current_season)

func update_stall_daily():
	stall._update_current_item_daily()

#更新洗盘子ui
func update_plate_ui(value):
	plate.visible = value
	$TextureButton.visible = not value
	update_inventory_ui(value)

#打开洗盘子ui
func open_plate_window():
	MouseController.is_window_open = true
	MouseController.change_mouse()
	
	plate.init()
	plate.scale = Vector2.ZERO
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_callback(update_plate_ui.bind(true))
	tween.tween_property(plate,"scale",Vector2(1,1),0.25)

#关闭洗盘子ui
func close_plate_window():
	MouseController.is_window_open = false
	MouseController.change_mouse()
	
	var tween = create_tween().set_ease(Tween.EASE_OUT)
	tween.tween_property(plate,"scale",Vector2.ZERO,0.25)
	tween.tween_callback(update_plate_ui.bind(false))

func update_healthy_bar():
	healthybar.value = Global.player_health

func _on_texture_button_button_down():
	if bag.visible:
		close_bag_window()
	else :
		open_bag_window()
