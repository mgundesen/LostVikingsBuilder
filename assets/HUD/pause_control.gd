extends Node2D

enum PauseType {Regular, Item, None}
var type = PauseType.None

var selectYes = false

func pause(pauseType):
	get_tree().paused = !get_tree().paused
	if type == PauseType.None:
		type = pauseType
	else:
		type = PauseType.None

func _process(_delta):
	if Input.is_action_just_pressed(&"Start") or (Input.is_action_just_pressed(&"B") and type == PauseType.Regular):
		if selectYes:
			get_tree().paused = false
			SceneControl.deathScene()
		else:
			pause(PauseType.Regular)
	
	$CanvasLayer.visible = type == PauseType.Regular
	if type == PauseType.Regular:
		$CanvasLayer/No.visible = !selectYes
		$CanvasLayer/Yes.visible = selectYes
		if Input.is_action_just_pressed(&"Right") and selectYes:
			selectYes = false
		if Input.is_action_just_pressed(&"Left") and !selectYes:
			selectYes = true
	else:
		$CanvasLayer.visible = false
		type = PauseType.None
	
