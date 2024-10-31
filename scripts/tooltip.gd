extends PanelContainer

@onready var title = $MarginContainer/VBoxContainer/title
@onready var desc = $MarginContainer/VBoxContainer/desc

var price:int
var current_amount:int
var item_info

@export var eat_button:PackedScene

@export var plant_resource:PlantResource
@export var seed_resource:SeedResource
@export var foodResource:FoodResource


func init(item,title_info,desc_info,value,quantity):
	item_info = item
	title.text = title_info
	
	price = value
	current_amount = quantity
	
	if desc_info != null:
		desc.text = "price:" + str(price) + "G" + desc_info
	else :
		desc.text = "price:" + str(price) + "G"
	
	var btn_instance = $MarginContainer/VBoxContainer/HBoxContainer/Eat
	if not item_info is FoodData:
		if btn_instance:
			btn_instance.queue_free()
	else :
		if not btn_instance:
			var instance = eat_button.instantiate()
			$MarginContainer/VBoxContainer/HBoxContainer.add_child(instance)
			instance.button_down.connect(_on_eat_button_down)


func _on_button_button_down():
	show_quantity_dialog()
	

func show_quantity_dialog():
	var dialogue = preload("res://scene/shop/quantity_dialog.tscn").instantiate()
	dialogue.init("sell",self, current_amount, price)
	get_parent().add_child(dialogue)


func confirm_sell(quantity):
	var total_cost = quantity * price
	MoneyManager.add_money(total_cost)
	
	if item_info is PlantData:
		for crop in plant_resource.get_plant_list():
			if crop.plant_name_resource.plant_name == item_info.plant_name_resource.plant_name:
				crop.quantity -= quantity
				get_parent()._on_tab_bar_tab_changed(2)
				break
	elif item_info is SeedData:
		for seed in seed_resource.get_seed_list():
			if seed.plantDataResource.plant_name_resource.plant_name == item_info.plantDataResource.plant_name_resource.plant_name:
				seed.add_quantity(-quantity)
				get_parent()._on_tab_bar_tab_changed(0)
				break
	elif item_info is FoodData:
		for dish in foodResource.get_food_list():
			if dish.get_food_name() == item_info.get_food_name():
				dish.quantity -= quantity
				get_parent()._on_tab_bar_tab_changed(1)
				break
	get_parent().update_money()


func _on_eat_button_down():
	for dish in foodResource.get_food_list():
		if dish.get_food_name() == item_info.get_food_name():
			dish.quantity -= 1
			Global.eat_food(item_info)
			get_parent()._on_tab_bar_tab_changed(1)
			break

