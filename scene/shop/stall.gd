extends Control

@export var shop_cell:PackedScene

@export var daily_items: Array[Resource] = []
@export var seasonal_items: Dictionary = {
	"Spring": [],
	"Summer": [],
	"Fall": [],
	"Winter": []
}

@export var max_daily_items: int = 8
@export var seasonal_item_limit: int = 2

var current_items: Array = []
var current_season_items: Array = []


func init():
	update_money_label()


func update_money_label():
	$Label.text = "money:\n" + str(MoneyManager.money) + "G"


func _update_current_item_daily():
	_update_daily_items()
	_on_shop_updated()


func _update_current_item_perseason(season):
	_update_seasonal_items(season)


func _on_shop_updated():
	var container = $NinePatchRect/MarginContainer/ScrollContainer/GridContainer
	for child in container.get_children():
		child.queue_free()
		
	for item in current_items:
		add_instance(container,item,5,5)
	
	for item in current_season_items:
		if MoneyManager.season_item_left.has(get_item_name(item)):
			add_instance(container,item,MoneyManager.season_item_left.get(get_item_name(item)),3)
		else :
			add_instance(container,item,3,3)
			MoneyManager.season_item_left[get_item_name(item)] = 3

func get_item_name(item):
	if item is FoodData:
		return item.get_food_name()
	elif item is SeedData:
		return item.get_seed_name()
	elif item is PlantData:
		return item.get_plant_name()

func add_instance(container,item,current,max):
	var item_instance = shop_cell.instantiate()
	var price = item.price + randi_range(-3,3)
	
	while  price < 0:
		price = item.price + randf_range(-3,3) 

	item_instance.init(item,price,current,max)

	item_instance.connect("purchase",update_money_label)
	container.add_child(item_instance)


func _update_daily_items():
	current_items.clear()
	var shuffled_items = daily_items.duplicate()
	shuffled_items.shuffle()
	
	for i in range(min(max_daily_items, shuffled_items.size())):
		current_items.append(shuffled_items[i])


func _update_seasonal_items(season: String):
	if seasonal_items.has(season):
		var shuffled_items = seasonal_items[season].duplicate()
		shuffled_items.shuffle()
		
		for i in range(min(seasonal_item_limit, shuffled_items.size())):
			current_season_items.append(shuffled_items[i])
