extends Control

@onready var load_panel = $load_data
@onready var about_panel = $about_panel

@export var save: PackedScene

func _ready():
	load_panel.visible = false
	about_panel.visible = false

func _on_texture_button_button_down():
	load_panel.visible = true
	load_panel.scale = Vector2.ZERO
	
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(load_panel,"scale",Vector2(1,1),0.25)

	update_save_container()

func _on_start_game_button_down():
	SaveManager.load_game()
	get_tree().change_scene_to_file("res://scene/main.tscn")

func _on_delete_button_down():
	SaveManager.delete_save_file()

func _on_back_button_down():
	
	var tween = create_tween().set_ease(Tween.EASE_OUT)
	tween.tween_property(load_panel,"scale",Vector2.ZERO,0.25)
	
	tween.tween_callback(update_load_pabel.bind(false))

func update_load_pabel(value):
	load_panel.visible = value


func update_save_container():
	add_save_to_container()

func add_save_to_container():
	var instance = save.instantiate()
