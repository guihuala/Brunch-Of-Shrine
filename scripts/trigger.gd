extends Node2D

@export var money_region_scene: PackedScene

@onready var time_system = $"../TimeSystem"

var player_in_area_shop = false
var player_in_area_kitchen = false
var player_in_area_stall = false
var player_in_plate_area = false

var player_in_bed_area = false

var current_region: Node2D = null
var current_money: int = 0

func _physics_process(_delta):
	if player_in_bed_area:
		if Input.is_action_just_pressed("open_window"):
			time_system.skip_to_next_morning()

func _on_shop_body_entered(body):
	if body.name == "player":
		player_in_area_shop = true
		MouseController.player_in_shop_area = true
		MouseController.change_mouse()


func _on_shop_body_exited(body):
	if body.name == "player":
		player_in_area_shop = false
		MouseController.player_in_shop_area = false
		MouseController.change_mouse()


func _on_kitchen_body_entered(body):
	if body.name == "player":
		player_in_area_kitchen = true
		MouseController.player_in_kitchen_area = true
		MouseController.change_mouse()


func _on_kitchen_body_exited(body):
	if body.name == "player":
		player_in_area_kitchen = false
		MouseController.player_in_kitchen_area = false
		MouseController.change_mouse()

func _on_stall_body_entered(body):
	if body.name == "player":
		player_in_area_stall = true
		MouseController.player_in_shop_area = true
		MouseController.change_mouse()


func _on_stall_body_exited(body):
	if body.name == "player":
		player_in_area_stall = false
		MouseController.player_in_shop_area = false
		MouseController.change_mouse()


func _on_plate_body_entered(body):
	if body.name == "player":
		player_in_plate_area = true
		MouseController.player_in_shop_area = true
		MouseController.change_mouse()


func _on_plate_body_exited(body):
	if body.name == "player":
		player_in_plate_area = false
		MouseController.player_in_shop_area = false
		MouseController.change_mouse()


func _on_bed_body_entered(body):
	if body.name == "player":
		player_in_bed_area = true


func _on_bed_body_exited(body):
	if body.name == "player":
		player_in_bed_area = false


func _create_new_region():
	if current_region != null:
		current_region.queue_free()

	current_region = money_region_scene.instantiate()
	current_money += 10
	current_region.init(current_money)
	current_region.global_position = Vector2(105, -125)
	add_child(current_region)
	
	current_region.connect("complete",_on_operation_completed)


func _on_operation_completed(amount):
	if current_region != null:
		current_region.queue_free()
	MoneyManager.add_money(amount)
	current_money = 0

	remove_region()


func remove_region():
	if current_region != null:
		current_region.queue_free()
	current_region = null



