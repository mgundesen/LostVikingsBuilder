extends AudioStreamPlayer

func _ready() -> void:
	if SceneControl.musicEnabled:
		play()
	else:
		stop()	

func _process(_delta: float) -> void:
	if SceneControl.pauseType() == SceneControl.PauseType.Regular:
		stream_paused = true
	else:
		stream_paused = false
