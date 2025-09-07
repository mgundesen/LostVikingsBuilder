extends Node2D

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed(&"B") or Input.is_action_just_pressed(&"Start"):
		SceneControl.nextScene()
