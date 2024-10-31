extends VBoxContainer

@export var item_info:Resource
@export var price:int
@export var amount:int

@export var plant_resource:PlantResource
@export var seed_resource:SeedResource
@export var foodResource:FoodResource

var current_amount

signal purchase

func init(item,price_value,current,max):
	item_info = item
	price = price_value
	amount = max
	current_amount = current
	
	update_price()
	update_item_info()
	update_amount()


func update_item_info():
	if item_info is SeedData:
		$item_info.set_item_info(item_info.plantDataResource.texture,null)
	else :
		$item_info.set_item_info(item_info.get_texture(),null)


func update_price():
	$Label.text = str(price) + "G"


func update_amount():
	$amount.text = str(current_amount) + "/" + str(amount)
	if current_amount == 0:
		$buy.disabled = true


func _on_buy_button_down():
	show_quantity_dialog()


func show_quantity_dialog():
	var dialogue = preload("res://scene/shop/quantity_dialog.tscn").instantiate()
	dialogue.init("purchase",self, current_amount, price)
	get_parent().get_parent().get_parent().add_child(dialogue)


func confirm_purchase(quantity):
	var total_cost = quantity * price

	if MoneyManager.money - total_cost >= 0:
		current_amount -= quantity
		MoneyManager.sub_money(total_cost)
		emit_signal("purchase")
		
		if MoneyManager.season_item_left.has(get_item_name(item_info)):
			MoneyManager.season_item_left[get_item_name(item_info)] = current_amount
		
		if item_info is PlantData:
			for crop in plant_resource.get_plant_list():
				if crop.plant_name_resource.plant_name == item_info.plant_name_resource.plant_name:
					crop.quantity += quantity
					break
		elif item_info is SeedData:
			for seed in seed_resource.get_seed_list():
				if seed.plantDataResource.plant_name_resource.plant_name == item_info.plantDataResource.plant_name_resource.plant_name:
					seed.add_quantity(quantity)
					break
		elif item_info is FoodData:
			for dish in foodResource.get_food_list():
				if dish.get_food_name() == item_info.get_food_name():
					dish.quantity += quantity
					break
		update_amount()
	else:
		print("Not enough money!")


func get_item_name(item):
	if item is FoodData:
		return item.get_food_name()
	elif item is SeedData:
		return item.get_seed_name()
	elif item is PlantData:
		return item.get_plant_name()
