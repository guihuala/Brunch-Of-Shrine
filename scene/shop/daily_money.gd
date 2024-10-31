extends Area2D

signal complete(amount)
var player_in_area = false
var current_money


func init(amount):
	current_money = amount


func _physics_process(_delta):
	if Input.is_action_just_pressed("open_window"):
		if player_in_area:
			emit_signal("complete",current_money)


func _on_body_entered(body):
	if body.name == "player":
		player_in_area = true
		MouseController.player_in_shop_area = true
		MouseController.change_mouse()
		

func _on_body_exited(body):
	if body.name == "player":
		player_in_area = false
		MouseController.player_in_shop_area = false
		MouseController.change_mouse()
