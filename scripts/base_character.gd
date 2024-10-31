extends CharacterBody2D
class_name BaseCharacter

@export var character_info:CharacterData

signal enter_character_area(character)
signal exit_character_area


func _on_area_2d_body_entered(body):
	if body.name == "player":
		MouseController.player_in_chat_area = true
		MouseController.change_mouse()
		emit_signal("enter_character_area",self)


func _on_area_2d_body_exited(body):
	if body.name == "player":
		MouseController.player_in_chat_area = false
		MouseController.change_mouse()
		emit_signal("exit_character_area")
