extends Node

@export var songs: Array[AudioStream]
@export var randomize_start = false

var currentSong: AudioStream
var currentSongIdx: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if randomize_start:
		currentSongIdx = randi_range(0, songs.size()-1)
	
	currentSong = songs[currentSongIdx]
	$AudioStreamPlayer.stream = currentSong
	$AudioStreamPlayer.play()
	var splits = currentSong.resource_path.rsplit("/")
	$ColorRect/Label.text = splits[splits.size()-1]
	$AudioStreamPlayer.volume_db = linear_to_db(0.2)
	$ColorRect/Volume.value = 20


func _on_play_pressed() -> void:
	$ColorRect/Play.visible = false
	$ColorRect/Pause.visible = true
	$AudioStreamPlayer.playing = true
	


func _on_pause_pressed() -> void:
	$ColorRect/Pause.visible = false
	$ColorRect/Play.visible = true
	$AudioStreamPlayer.playing = false
	


func _on_prev_pressed() -> void:
	var len = songs.size()
	currentSongIdx -= randi_range(1, songs.size()-1)
	#currentSongIdx-=1
	if currentSongIdx < 0:
		currentSongIdx = len-1
		
	currentSong = songs[currentSongIdx]
	$AudioStreamPlayer.stream = currentSong
	$AudioStreamPlayer.play()
	var splits = currentSong.resource_path.rsplit("/")
	$ColorRect/Label.text = splits[splits.size()-1]
		


func _on_next_pressed() -> void:
	var len = songs.size()
	currentSongIdx += randi_range(0, songs.size()-1)
	#currentSongIdx+=1
	if currentSongIdx >= len:
		currentSongIdx = 0
		
	currentSong = songs[currentSongIdx]
	$AudioStreamPlayer.stream = currentSong
	$AudioStreamPlayer.play()
	var splits = currentSong.resource_path.rsplit("/")
	$ColorRect/Label.text = splits[splits.size()-1]


func _on_volume_value_changed(value: float) -> void:
	$AudioStreamPlayer.volume_db = linear_to_db(value/100)


func _on_audio_stream_player_finished() -> void:
	var len = songs.size()
	currentSongIdx+=1
	if currentSongIdx >= len:
		currentSongIdx = 0
		
	currentSong = songs[currentSongIdx]
	$AudioStreamPlayer.stream = currentSong
	$AudioStreamPlayer.play()
	var splits = currentSong.resource_path.rsplit("/")
	$ColorRect/Label.text = splits[splits.size()-1]
