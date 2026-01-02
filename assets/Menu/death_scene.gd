extends Node2D

var selectYes = true

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed(&"A") or Input.is_action_just_pressed(&"B") or Input.is_action_just_pressed(&"Start"):
		if selectYes:
			SceneControl.continueScene()
		else:
			SceneControl.mainScene()

	$CanvasLayer/No.visible = !selectYes
	$CanvasLayer/Yes.visible = selectYes
	if Input.is_action_just_pressed(&"Right") and selectYes:
		selectYes = false
	if Input.is_action_just_pressed(&"Left") and !selectYes:
		selectYes = true
	
	
	
