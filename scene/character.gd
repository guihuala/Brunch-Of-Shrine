extends Node2D

@export var character_npc:CharacterResource
@export var character_guest:CharacterResource

@export var guest_position:Vector2

var current_character
var character_dictionary:Dictionary = {}
var npc_instances: Array = []
var guest_instances: Array = []

func init():
	generate_npc()
	generate_guest()


func over():
	remove_guest()
	remove_npc()


func _on_character_enter(character):
	current_character = character


func _on_character_exit():
	current_character = null


func get_quest(character):
	var num = character.get_quest_size()
	if num != 0:
		var index = randi() % num
		return character.quest[index]
	else :
		return null


func generate_npc():
	var npc_positions = [
		Vector2(0,0),
		Vector2(50, 0),
	]
	var position_index = 0
	
	for child in character_npc.get_character_list():
		
		var instance = child.instantiate()
		
		instance.connect("enter_character_area",_on_character_enter)
		instance.connect("exit_character_area",_on_character_exit)
		instance.connect("save_favorbility",save_favorbility)
		add_child(instance)
		
		if position_index < npc_positions.size():
			instance.position = npc_positions[position_index]
			position_index += 1
		
		npc_instances.append(instance)
		character_dictionary[instance.character_info.character_name] = get_quest(instance.character_info)
		
		
		if MoneyManager.character_favorbility.has(instance.character_info.character_name):
			instance.init(MoneyManager.character_favorbility[instance.character_info.character_name])
		else :
			instance.init(0)
			MoneyManager.character_favorbility[instance.character_info.character_name] = 0


func save_favorbility(favorbility,name):
	MoneyManager.character_favorbility[name] = favorbility


func generate_guest():
	var num = character_guest.get_character_list_size()
	if num == 0:
		return

	var index = randi() % character_guest.get_character_list_size()
	
	var instance = character_guest.character_list[index].instantiate()
	
	instance.connect("enter_character_area",_on_character_enter)
	instance.connect("exit_character_area",_on_character_exit)
	add_child(instance)
	instance.global_position = guest_position
	
	guest_instances.append(instance)
	character_dictionary[instance.character_info.character_name] = get_quest(instance.character_info)


func remove_npc():
	for npc in npc_instances:
		if is_instance_valid(npc):
			
			if npc.is_eat == false:
				npc.sub_favorbility(5)
				
			npc.queue_free()
	npc_instances.clear()


func remove_guest():
	for guest in guest_instances:
		if is_instance_valid(guest):
			guest.queue_free()
	guest_instances.clear()
