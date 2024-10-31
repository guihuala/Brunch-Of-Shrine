extends Button

var food_item:Recipe

signal select_recipe(Recipe)

func init(recipe):
	food_item = recipe
	update_item_containers()

func update_item_containers():
	update_ui($item_info,food_item.result.get_texture(),null)
	$Label.text = food_item.food_name

func update_ui(node:Node,item_texture,item_quantity):
	node.set_item_info(item_texture,item_quantity)

func _on_button_down():
	emit_signal("select_recipe",food_item)
