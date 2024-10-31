extends Control

@onready var line_edit = $NinePatchRect/MarginContainer/VBoxContainer/HBoxContainer2/LineEdit
@onready var confirm_button = $NinePatchRect/MarginContainer/VBoxContainer/HBoxContainer/buy


var shop_cell
var min_quantity: int = 0
var max_quantity:int = 10
var price_per_unit
var current_type


func init(type,cell, max_qty, price):
	current_type = type
	
	var title = $NinePatchRect/MarginContainer/VBoxContainer/Label
	if type == "purchase":
		title.text = "Choose your purchase quantity"
	elif type == "sell":
		title.text = "Select the quantity you want to sell"
	
	shop_cell = cell
	max_quantity = max_qty
	price_per_unit = price


func _on_buy_button_down():
	var quantity = int(line_edit.text)
	if current_type == "purchase":
		shop_cell.confirm_purchase(quantity)
	elif current_type == "sell":
		shop_cell.confirm_sell(quantity)
	queue_free()


func _on_cancel_button_down():
	queue_free()


func _on_sub_button_down():
	var current_value = int(line_edit.text)
	current_value = max(current_value - 1, min_quantity)
	line_edit.text = str(current_value)


func _on_add_button_down():
	var current_value = int(line_edit.text)
	current_value = min(current_value + 1, max_quantity)
	line_edit.text = str(current_value)


func _on_line_edit_text_changed(new_text):
	var filtered_text = new_text.strip_edges()
	if not filtered_text.is_valid_integer():
		line_edit.text = "0"
	else:
		var value = int(filtered_text)
		line_edit.text = str(clamp(value, min_quantity, max_quantity))
