extends AudioStreamPlayer

func _ready() -> void:
	if SceneControl.getMusicEnabled():
		play()
	else:
		stop()	
