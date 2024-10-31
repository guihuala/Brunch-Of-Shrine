extends HBoxContainer

var plantItem: PlantData
var seedItem: SeedData

@onready var lineEdit = $LineEdit
@onready var rewards = $LineEdit2

func initialize(plant:PlantData,seedData: SeedData):
	plantItem = plant
	seedItem = seedData
	update_item_containers()


func update_slots():
	$PlantInfo1.set_label(plantItem.quantity)
	$PlantInfo2.set_label(seedItem.get_quantity())


func update_item_containers():
	update_ui($PlantInfo1,plantItem.get_texture(),plantItem.quantity)
	update_ui($PlantInfo2,seedItem.get_texture(),seedItem.get_quantity())


func update_ui(node:Node,item_texture,item_quantity):
	node.set_item_info(item_texture,item_quantity)


func _on_texture_button_button_down():
	if plantItem != null and seedItem != null:
		
		var num = int(lineEdit.text)
		var rewards_num = int(rewards.text)
		
		if plantItem.quantity >= num:
			seedItem.add_quantity(rewards_num)
			plantItem.quantity -= num
			update_item_containers()
		else :
			$PlantInfo1.play_flash_anim()


func _on_line_edit_text_changed(new_text):
	var filtered_text = ""
	for c in new_text:
		if c.is_valid_int():
			filtered_text += c
	if new_text != filtered_text:
		lineEdit.text = filtered_text
		
	rewards.text = lineEdit.text
	
