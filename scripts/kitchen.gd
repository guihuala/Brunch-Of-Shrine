extends Control

@export var recipeResource:RecipeResource
@export var plantResource:PlantResource
@export var foodResource:FoodResource

@export var recipe_info:PackedScene
@export var item_info:PackedScene

@onready var cook_timer = $cookTimer

var selected_recipe:Recipe
var window_is_open

func init():
	window_is_open = true
	close_anim()
	add_conversion_containers()
	update_plate_quantity()

func close_anim():
	$wait_anim.visible = false


#添加菜谱
func add_conversion_containers():
	for child in $NinePatchRect/MarginContainer/maincontant/recipesContainer/ScrollContainer/recipes.get_children():
		child.queue_free()

	for child in recipeResource.get_recipe_list():
		instance_conversion_scene(child)
	
	var first_recipe = $NinePatchRect/MarginContainer/maincontant/recipesContainer/ScrollContainer/recipes.get_child(0)
	_on_recipe_select(first_recipe.food_item)


#菜谱实例添加到组件
func instance_conversion_scene(value1):
	var scene = recipe_info.instantiate()
	$NinePatchRect/MarginContainer/maincontant/recipesContainer/ScrollContainer/recipes.add_child(scene)
	scene.init(value1)
	scene.connect("select_recipe",_on_recipe_select)


func update_quantity():
	for child in get_children():
		child.update_slots()


func update_plate_quantity():
	var label = $Label
	label.text = "plate:" + str(MoneyManager.plate)


func update_ingerdients_info(value):
	var container = $NinePatchRect/MarginContainer/maincontant/recipesinfo/ScrollContainer/VBoxContainer/ingredientsContainer
	
	for child in container.get_children():
		child.queue_free()
		
	for child in value:
		var scene = item_info.instantiate()
		container.add_child(scene)
		scene.set_item_info(child.texture,1)


func update_results_info(value):
	var container = $NinePatchRect/MarginContainer/maincontant/recipesinfo/ScrollContainer/VBoxContainer/resultsContainers
	
	for child in container.get_children():
		child.queue_free()
	
	var scene = item_info.instantiate()
	container.add_child(scene)
	scene.set_item_info(value.texture,1)

func update_label(value):
	$NinePatchRect/MarginContainer/maincontant/recipesinfo/ScrollContainer/VBoxContainer/foodname.text = value.food_name
	$NinePatchRect/MarginContainer/maincontant/recipesinfo/ScrollContainer/VBoxContainer/Label.text = "waste time:" + str(value.waste_time) + "\n" + "price:" + str(value.price)

func _on_recipe_select(value):
	selected_recipe = value
	update_label(value)
	update_ingerdients_info(value.Ingredients)
	update_results_info(value.result)


func cook():
	$cookTimer.stop()

	var needed_crops = selected_recipe.get_ingredients_list()
	for ingredient in needed_crops:
		for plant in plantResource.get_plant_list():
			if plant.plant_name_resource.plant_name == ingredient.plant_name_resource.plant_name:
				plant.quantity -= 1
				break

	var result = selected_recipe.get_result()

	for dish in foodResource.get_food_list():
		if dish.food_name == result.food_name:
			dish.quantity += 1
			MoneyManager.use_plate()
			update_plate_quantity()
			break


func _on_cook_timer_timeout():
	close_anim()
	cook()
	$wait_anim/ProgressBar.value = 0


func _on_cook_button_pressed():
	if not window_is_open:
		return
	
	if MoneyManager.plate == 0:
		return

	if selected_recipe and selected_recipe.get_ingredients_list() and selected_recipe.get_result():
		var needed_crops = selected_recipe.get_ingredients_list()
		var can_cook = true

		for ingredient in needed_crops:
			var found = false
			for plant in plantResource.get_plant_list():
				if plant.plant_name_resource.plant_name == ingredient.plant_name_resource.plant_name:
					if plant.quantity >= 1:
						found = true
					break
			
			if not found:
				can_cook = false
				break

		if can_cook:
			$wait_anim/ProgressBar.max_value = selected_recipe.waste_time
			cook_timer.start(selected_recipe.waste_time)
			$wait_anim.visible = true
		else:
			print("Not enough resources to cook!")


func _process(_delta):
	if cook_timer.is_stopped() == false:
		$wait_anim/ProgressBar.value = cook_timer.wait_time - cook_timer.time_left
