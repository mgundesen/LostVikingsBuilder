extends Area2D

func _process(_delta):
	var player = PlayerUtil.getOverlappingActive(self)
	var validPlayerState = player and player.state == PlayerBase.State.Free and player.is_on_floor()
	if Input.is_action_just_pressed(&"A") and validPlayerState:
		SceneControl.playSound($AudioStreamPlayer2D)
		player.setState(PlayerBase.State.Inflating)
