extends Node

@export var songs: Array[AudioStream]

var currentSong: AudioStream
var currentSongIdx: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	currentSong = songs[0]
	$AudioStreamPlayer.stream = currentSong
	$AudioStreamPlayer.play()
	var splits = currentSong.resource_path.rsplit("/")
	$ColorRect/Label.text = splits[splits.size()-1]
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


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
	currentSongIdx-=1
	if currentSongIdx < 0:
		currentSongIdx = len-1
		
	currentSong = songs[currentSongIdx]
	$AudioStreamPlayer.stream = currentSong
	$AudioStreamPlayer.play()
	var splits = currentSong.resource_path.rsplit("/")
	$ColorRect/Label.text = splits[splits.size()-1]
		


func _on_next_pressed() -> void:
	var len = songs.size()
	currentSongIdx+=1
	if currentSongIdx >= len:
		currentSongIdx = 0
		
	currentSong = songs[currentSongIdx]
	$AudioStreamPlayer.stream = currentSong
	$AudioStreamPlayer.play()
	var splits = currentSong.resource_path.rsplit("/")
	$ColorRect/Label.text = splits[splits.size()-1]


func _on_play_mouse_entered() -> void:
	pass
	#$ColorRect/Play.modulate(Color.DARK_GRAY)


func _on_play_mouse_exited() -> void:
	pass
	#$ColorRect/Play.modulate(Color.WHITE)


func _on_pause_mouse_entered() -> void:
	pass
	#$ColorRect/Pause.modulate(Color.WHITE)


func _on_pause_mouse_exited() -> void:
	pass
	#$ColorRect/Pause.modulate(Color.WHITE)


func _on_prev_mouse_entered() -> void:
	pass
	#$ColorRect/Prev.modulate(Color.DARK_GRAY)


func _on_prev_mouse_exited() -> void:
	pass
	#$ColorRect/Prev.modulate(Color.WHITE)


func _on_next_mouse_entered() -> void:
	pass
	#$ColorRect/Next.modulate(Color.DARK_GRAY)


func _on_next_mouse_exited() -> void:
	pass
	#$ColorRect/Next.modulate(Color.WHITE)
