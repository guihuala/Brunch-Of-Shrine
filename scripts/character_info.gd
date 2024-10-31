extends Control

@export var item_info:PackedScene
@export var food_slot:PackedScene

@export var plant_resource:PlantResource
@export var seed_resource:SeedResource
@export var foodResource:FoodResource


@onready var submit_button = $quest/MarginContainer/ScrollContainer/VBoxContainer/cookButton
@onready var next_button = $next
@onready var pre_button = $pre


var character_instance
var chara_info:CharacterData
var chara_quest:QuestData

var if_completed:bool = false
var current_page: int = 0
var is_npc:bool

var selected_brunch:Dictionary = {}


func init(info,quest):
	chara_info = info.character_info
	character_instance = info
	
	chara_quest = quest
	is_npc = chara_info.isNPC
	update_ui(quest)


func update_ui(quest):
	update_chara_info(quest)
	update_favor_label()
	update_texture()
	update_chara_salutation()
	
	if is_npc:
		update_page(0)
	else :
		update_page(1)
		next_button.visible = false
		pre_button.visible = false


func update_page(page: int):
	current_page = page
	if page == 0:
		$quest.hide()
		$chatbox.hide()
		$favorability.show()
		$chara_favor_info.show()
		
		update_foodlist()
		update_favorability()

		next_button.visible = is_npc
		pre_button.visible = false
	elif page == 1:
		$quest.show()
		$chatbox.show()
		$favorability.hide()
		$chara_favor_info.hide()
		
		update_requests(chara_quest.require)
		update_rewards(chara_quest.reward, chara_quest.reward_amount)
		
		next_button.visible = false
		pre_button.visible = true


#npc角色好感度相关
func update_foodlist():
	var container = $favorability/MarginContainer/VBoxContainer/ScrollContainer/GridContainer
	var container_brunch = $favorability/MarginContainer/VBoxContainer/NinePatchRect/MarginContainer/HBoxContainer/brunch_list
	
	for child in container.get_children():
		child.queue_free()
	
	for child in container_brunch.get_children():
		child.queue_free()
	
	for food in foodResource.get_food_list():
		if food.get_quantity() > 0:
			var scene = food_slot.instantiate()
			
			scene.connect("button_down",_on_slot_button_down)
			
			container.add_child(scene)
			scene.setup(food,food.get_quantity())


#背包内的slot
func _on_slot_button_down(food_data,slot):
	if slot.current_quantity > 0:
		selected_brunch[add_food_to_list(food_data)] = slot
	
		slot.current_quantity -= 1
		slot.update_quantity()
	else :
		return


#已选择的slot
func _on_brunch_button_down(food_data,slot):
	if selected_brunch.has(slot):
		var slot_to_return = selected_brunch.get(slot)
		
		slot_to_return.current_quantity += 1
		slot_to_return.update_quantity()
		
		selected_brunch.erase(slot)
		
		slot.queue_free()


func add_food_to_list(food_data):
	var container = $favorability/MarginContainer/VBoxContainer/NinePatchRect/MarginContainer/HBoxContainer/brunch_list
	
	if container.get_children().size() < 3:
		var scene = food_slot.instantiate()
		container.add_child(scene)
		
		scene.connect("button_down",_on_brunch_button_down)
		
		scene.setup(food_data,1)
		return scene


func update_favor_label():
	var label = $favorability/MarginContainer/VBoxContainer/Label
	label.text = "Choose brunch for " + chara_info.character_name


func update_favorability():
	var progressbar = $chara_favor_info/ProgressBar
	var current_favorbility = character_instance.current_favorability
	var container = $chara_favor_info/HBoxContainer
	var scene = $chara_favor_info/HBoxContainer/item_info
	
	progressbar.value = current_favorbility
	
	if character_instance.get_current_reward():
		var reward = character_instance.get_current_reward()
		scene.set_item_info(reward.texture,1)


func eat_brunch():
	var list = $favorability/MarginContainer/VBoxContainer/NinePatchRect/MarginContainer/HBoxContainer/brunch_list

	for child in list.get_children():
		for food in foodResource.get_food_list():
			if child.foodData.get_food_name() == food.get_food_name() and character_instance.current_favorability < 100:
				food.quantity -= 1

				var favorbility_change = character_instance.calculate_favorability(child.foodData)
				character_instance.add_favorbility(favorbility_change)
				update_favorability()
				
				child.queue_free()
				MoneyManager.plate_dirty += 1
				character_instance.is_eat = true

func _on_texture_button_button_down():
	eat_brunch()


func _on_get_button_down():
	if character_instance.current_favorability == 100:
		var reward = character_instance.get_current_reward()
		for crop in plant_resource.get_plant_list():
			if crop.get_plant_name() == reward.get_plant_name():
				crop.quantity += 1
				
		character_instance.restart()
		update_favorability()
	else :
		return


#任务相关
func update_requests(value):
	var label = $quest/MarginContainer/ScrollContainer/VBoxContainer/request
	var container = $quest/MarginContainer/ScrollContainer/VBoxContainer/GridContainer
	
	label.visible = true
	container.visible = true
	
	for child in container.get_children():
		child.queue_free()
	
	if value.size() != 0:
		for child in value:
			var scene = item_info.instantiate()
			container.add_child(scene)
			scene.set_item_info(child.get_texture(),1)
	else :
		label.visible = false
		container.visible = false


func update_rewards(value,amount):
	var container = $quest/MarginContainer/ScrollContainer/VBoxContainer/GridContainer2
	
	for child in container.get_children():
		child.queue_free()
	
	var scene = item_info.instantiate()
	container.add_child(scene)
	scene.set_item_info(value.get_texture(),amount)


func update_chara_info(quest):
	var chara_name = $quest/MarginContainer/ScrollContainer/VBoxContainer/HBoxContainer/VBoxContainer/character_name
	var quest_desc = $quest/MarginContainer/ScrollContainer/VBoxContainer/HBoxContainer/VBoxContainer/desc
	
	chara_name.text = chara_info.character_name
	quest_desc.text = quest.get_desc()


func update_texture():
	var character_main_texture = $quest/MarginContainer/ScrollContainer/VBoxContainer/HBoxContainer/TextureRect
	var salutation_texture = $Sprite2D
	
	character_main_texture.texture = chara_info.get_character_texture()
	salutation_texture.texture = chara_info.get_character_texture()


func update_chara_salutation():
	var label = $chatbox/MarginContainer/Label
	label.text = random_character_salutation()


func random_character_salutation():
	var num = chara_info.get_character_salutation_size()
	var index = randi() % num
	
	return chara_info.character_salutation[index]


func submit():
	if_completed = true
	submit_button.disabled = true
	
	for child in chara_quest.require:
		if child is PlantData:
			for crop in plant_resource.get_plant_list():
				if crop.plant_name_resource.plant_name == child.plant_name_resource.plant_name:
					crop.quantity -= 1
					break
		elif child is SeedData:
			for seed in seed_resource.get_seed_list():
				if seed.plantDataResource.plant_name_resource.plant_name == child.plantDataResource.plant_name_resource.plant_name:
					seed.quantity -= 1
					break
		elif child is FoodData:
			for dish in foodResource.get_food_list():
				if dish.get_food_name() == child.get_food_name():
					dish.quantity -= 1
					break
	# 添加奖励物品
	add_rewards()


func add_rewards():
	var reward = chara_quest.reward
	var amount = chara_quest.reward_amount
	
	if reward is PlantData:
		for crop in plant_resource.get_plant_list():
			if crop.plant_name_resource.plant_name == reward.plant_name_resource.plant_name:
				crop.quantity += amount
				break
	elif reward is SeedData:
		for seed in seed_resource.get_seed_list():
			if seed.plantDataResource.plant_name_resource.plant_name == reward.plantDataResource.plant_name_resource.plant_name:
				seed.quantity += amount
				break
	elif reward is FoodData:
		for dish in foodResource.get_food_list():
			if dish.get_food_name() == reward.get_food_name():
				dish.quantity += amount
				break


#submit按钮
func _on_cook_button_button_down():
	var can_submit = true
	

	if chara_quest.require == null:
		can_submit = true
		
	else :
		for child in chara_quest.require:
			var found = false
			
			if child is PlantData:
				for crop in plant_resource.get_plant_list():
					if crop.plant_name_resource.plant_name == child.plant_name_resource.plant_name:
						if crop.quantity >= 1:
							found = true
						break
			elif child is SeedData:
				for seed in seed_resource.get_seed_list():
					if seed.plantDataResource.plant_name_resource.plant_name == child.plantDataResource.plant_name_resource.plant_name:
						if seed.quantity >= 1:
							found = true
						break
			elif child is FoodData:
				for dish in foodResource.get_food_list():
					if dish.get_food_name() == child.get_food_name():
						if dish.quantity >= 1:
							found = true
						break
			
			if not found:
				can_submit = false
	
	if can_submit:
		submit()


#翻页按钮
func _on_pre_button_down():
	if is_npc:
		update_page(0)


func _on_next_button_down():
	if is_npc:
		update_page(1)
