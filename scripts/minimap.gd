extends NinePatchRect

var tilemap:TileMap
var player:CharacterBody2D

@onready var player_icon = $SubViewportContainer/SubViewport/Sprite2D


func _process(_delta):
	player_icon.position = player.position
