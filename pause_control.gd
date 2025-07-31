extends Node2D

var selectYes = false

func _process(_delta):
	if Input.is_action_just_pressed(&"Start"):
		get_tree().paused = !get_tree().paused
	var paused = get_tree().paused
	$CanvasLayer.visible = paused
	
	if paused:
		if Input.is_action_just_pressed(&"Right") and selectYes:
			selectYes = false
		if Input.is_action_just_pressed(&"Left") and !selectYes:
			selectYes = true
	
	$CanvasLayer/No.visible = !selectYes
	$CanvasLayer/Yes.visible = selectYes
