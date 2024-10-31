extends Node

@onready var music_player = $MusicPlayer
@onready var sfx_player = $SFXPlayer

var music_volume: float = 0.8
var sfx_volume: float = 0.8


var music_percent = 80
var sfx_percent = 80

func _ready():
	update_volumes()

func update_volumes():
	music_player.volume_db = linear_to_db(music_volume)
	sfx_player.volume_db = linear_to_db(sfx_volume)


func set_music_volume(value: float):
	music_percent = value
	music_volume = value / 100
	update_volumes()

func set_sfx_volume(value: float):
	sfx_percent = value
	sfx_volume = value / 100
	update_volumes()

func play_music(stream: AudioStream):
	music_player.stream = stream
	music_player.play()

func play_sfx(stream: AudioStream):
	sfx_player.stream = stream
	sfx_player.play()
