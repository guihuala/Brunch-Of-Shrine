extends Node2D

var item_info:PlantData

@onready var plant_resource = preload("res://resource/plant_resource.tres")
@onready var plant_resource_spring = preload("res://resource/season_plant_resource/spring_plant_resource.tres")
@onready var plant_resource_summer = preload("res://resource/season_plant_resource/summer_plant_resource.tres")
@onready var plant_resource_fall = preload("res://resource/season_plant_resource/fall_plant_resource.tres")
@onready var plant_resource_winter = preload("res://resource/season_plant_resource/winter_plant_resource.tres")

func init(season):
	item_info = get_item_info_for_season(season)
	update_texture(item_info)


func update_texture(item):
	if item:
		$TextureRect.texture = item.get_texture()


func get_item_info_for_season(season):
	var resource: PlantData
	match season:
		"Spring":
			resource =  get_random_item_from_resource(plant_resource_spring)
		"Summer":
			resource = get_random_item_from_resource(plant_resource_summer)
		"Fall":
			resource =  get_random_item_from_resource(plant_resource_fall)
		"Winter":
			resource =  get_random_item_from_resource(plant_resource_winter)
			
	if resource:
		return resource
	return null


func get_random_item_from_resource(resource):
	var length = resource.get_season_size()
	
	if length > 0:
		var random_index = randi() % length
		return resource.get_season_list()[random_index]
	return null


func _on_area_2d_body_entered(body):
	if body.name == "player":
		update_item_resource()


func update_item_resource():
	for child in plant_resource.get_plant_list():
		if child.get_plant_name() == item_info.get_plant_name():
			child.quantity += 1
			queue_free()


