extends Area2D

func _process(_delta):
	var player = PlayerUtil.getOverlappingActive(self)
	if player and Input.is_action_just_pressed(&"A") and player.state == PlayerBase.State.Free:
		SceneControl.playSound($AudioStreamPlayer2D)
		player.setState(PlayerBase.State.Inflating)
