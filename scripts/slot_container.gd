extends PanelContainer

signal  slot_selected(slot_pos)

@onready var item_info = $item_info

var seedDataResource:SeedData

func setup(value):
	seedDataResource = value
	seedDataResource.quantity_changed.connect(_on_quantity_changed)
	item_info.set_item_info(seedDataResource.get_texture(),seedDataResource.get_quantity())

func _on_texture_button_button_down():
	if seedDataResource != null and seedDataResource.seed_left():
		Global.emit_signal("seed_changed",seedDataResource)
	emit_signal("slot_selected",position)


func update_quantity():
	item_info.set_label(seedDataResource.get_quantity())


func _on_quantity_changed(new_quantity):
	item_info.set_label(new_quantity)


func play_slot_item_empty():
	$item_info.play_flash_anim()
