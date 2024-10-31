extends Node

@onready var harvest_cursor = preload("res://assets/others/mouse_harvest.png")
@onready var cook_cursor = preload("res://assets/others/mouse_cook.png")
@onready var shop_cursor = preload("res://assets/others/mouse_shop.png")
@onready var chat_cursor = preload("res://assets/others/mouse_chat.png")
@onready var default_cursor = preload("res://assets/others/mouse.png")

var player_in_shop_area = false
var player_in_kitchen_area = false
var player_in_harvest_area = false
var player_in_chat_area = false

var is_window_open = false

func _ready():
	# 设置默认的鼠标图案
	Input.set_custom_mouse_cursor(default_cursor)

func change_mouse():
	if not is_window_open:
		if player_in_kitchen_area:
			Input.set_custom_mouse_cursor(cook_cursor)
			
		elif not_player_in_other_area():
			Input.set_custom_mouse_cursor(default_cursor)
			
		elif player_in_harvest_area:
			Input.set_custom_mouse_cursor(harvest_cursor)
			
		elif player_in_shop_area:
			Input.set_custom_mouse_cursor(shop_cursor)
			
		elif player_in_chat_area:
			Input.set_custom_mouse_cursor(chat_cursor)
	else :
		Input.set_custom_mouse_cursor(default_cursor)


func not_player_in_other_area():
	if not player_in_harvest_area and not player_in_kitchen_area and not player_in_shop_area and not player_in_chat_area:
		return true
