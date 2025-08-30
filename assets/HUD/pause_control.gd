extends Node2D

var selectYes = false

func _process(_delta):
	var relatedPause = SceneControl.pauseType() == SceneControl.PauseType.Regular
	if Input.is_action_just_pressed(&"Start") or (Input.is_action_just_pressed(&"B") and relatedPause):
		if relatedPause:
			SceneControl.unpause()
			if selectYes:
				SceneControl.deathScene()
		else:
			SceneControl.setPause(SceneControl.PauseType.Regular)
	
	$CanvasLayer.visible = relatedPause
	if relatedPause:
		$CanvasLayer/No.visible = !selectYes
		$CanvasLayer/Yes.visible = selectYes
		if Input.is_action_just_pressed(&"Right") and selectYes:
			selectYes = false
		if Input.is_action_just_pressed(&"Left") and !selectYes:
			selectYes = true
	else:
		$CanvasLayer.visible = false
	
