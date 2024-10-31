extends CharacterBody2D

signal plant
signal hoeing
signal harvest

@onready var animated_sprite_2d = $AnimatedSprite2D

@export var move_speed:float = 70.0

var direction:Vector2 = Vector2.ZERO

var is_hoeing:bool = false

func _physics_process(_delta):
	direction = Vector2.ZERO
	
	if Input.is_action_just_pressed("hoeing"):
		toggle_hoe()
	
	if Input.is_action_pressed("ui_left"):
		animated_sprite_2d.play("side")
		animated_sprite_2d.flip_h = true
		direction = Vector2.LEFT
		
	elif Input.is_action_pressed("ui_right"):
		animated_sprite_2d.play("side")
		animated_sprite_2d.flip_h = false
		direction = Vector2.RIGHT
		
	elif Input.is_action_pressed("ui_up"):
		animated_sprite_2d.play("back")
		animated_sprite_2d.flip_h = false
		direction = Vector2.UP
		
	elif Input.is_action_pressed("ui_down"):
		animated_sprite_2d.play("front")
		animated_sprite_2d.flip_h = false
		direction = Vector2.DOWN
	else :
		animated_sprite_2d.stop()
	
	if Input.is_action_just_pressed("plant"):
		if not is_hoeing:
			emit_signal("plant")
		else:
			emit_signal("hoeing")
	
	if Input.is_action_just_pressed("harvest"):
		emit_signal("harvest")
	
	direction = direction.normalized()
	
	velocity = direction * move_speed
	move_and_slide()
	
func toggle_hoe():
	is_hoeing = not is_hoeing
