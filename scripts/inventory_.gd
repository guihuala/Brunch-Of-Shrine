extends PanelContainer

@export var slotScene: PackedScene
@export var seedResource:SeedResource

@onready var selector_texture = $MarginContainer/selected
@onready var grid_container = $MarginContainer/GridContainer


func init():
	grid_container.columns = seedResource.get_size()
	add_new_slot_seed(seedResource.get_seed_list())


func add_new_slot_seed(SeedArray:Array[SeedData]):
	for child in SeedArray:
		instance_slot(child)
		
	var firstSlot = grid_container.get_child(0)
	Global.emit_signal("seed_changed",firstSlot.seedDataResource)
	changed_selected_slot(firstSlot.position)


func update_inventory():
	for child in grid_container.get_children():
		child.update_quantity()


func _on_slot_selected(value):
	changed_selected_slot(value)


func changed_selected_slot(slot_pos):
	selector_texture.position.x = slot_pos.x + $MarginContainer.get_theme_constant("margin_left")


func instance_slot(seedData:SeedData):
	var slot = slotScene.instantiate()
	grid_container.add_child(slot)
	slot.connect("slot_selected",_on_slot_selected)
	slot.setup(seedData)


func is_slot_empty(seedData):
	for child in grid_container.get_children():
		if child.seedDataResource == seedData:
			child.play_slot_item_empty()
