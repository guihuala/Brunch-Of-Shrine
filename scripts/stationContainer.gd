extends VBoxContainer

@export var seedExtractorScene: PackedScene
@export var plantResource: PlantResource
@export var seedResource: SeedResource

func _ready():
	add_conversion_containers()

func add_conversion_containers():
	for child in plantResource.get_plant_list():
		var seed = seedResource.get_seed_data(child.get_plant_name())
		if seed != null:
			instance_conversion_scene(child, seed)


func instance_conversion_scene(value1,value2):
	var scene = seedExtractorScene.instantiate()
	add_child(scene)
	scene.initialize(value1,value2)


func update_plant_seed_quantity():
	for child in get_children():
		child.update_slots()
