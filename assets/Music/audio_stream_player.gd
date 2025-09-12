extends AudioStreamPlayer

func _ready() -> void:
	if SceneControl.getMusicEnabled():
		play()
	else:
		stop()	

func _process(delta: float) -> void:
	if SceneControl.pauseType() == SceneControl.PauseType.Regular:
		stream_paused = true
	else:
		stream_paused = false
