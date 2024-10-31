extends PanelContainer

@onready var item_info = $item_info

var foodData:FoodData

signal button_down()

var current_quantity

func setup(data,quantity):
	foodData = data
	current_quantity = quantity
	item_info.set_item_info(foodData.get_texture(),current_quantity)


func update_quantity():
	item_info.set_label(current_quantity)


func _on_texture_button_button_down():
	emit_signal("button_down",foodData,self)
