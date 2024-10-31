extends Control

@onready var music_slider = $Panel/NinePatchRect/MusicSlider
@onready var sfx_slider = $Panel/NinePatchRect/SFXSlider
@onready var time_label = $Panel/time_label

func _ready():
	hide()
	music_slider.value = AudioManager.music_percent
	sfx_slider.value = AudioManager.sfx_percent
	
	update_time_label()

func resume_game():
	pass

func _on_music_slider_value_changed(value):
	AudioManager.set_music_volume(value)

func _on_sfx_slider_value_changed(value):
	AudioManager.set_sfx_volume(value)

func update_time_label():
	var current_time = Time.get_datetime_dict_from_system()
	
	var time_string = "%02d.%02d.%02d" % [current_time["year"], current_time["month"], current_time["day"]]
	
	time_label.text = time_string
	
	await get_tree().create_timer(10.0).timeout
	update_time_label()
