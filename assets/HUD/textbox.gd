extends CanvasLayer

var textIndex = 0
var endDialog = false

func _startDialog():
	SceneControl.setPause(SceneControl.PauseType.Dialog)
	updateTextbox()

func _ready():
	visible = true
	_startDialog()

func setText(color, text):
	var stylebox = $MarginContainer/Panel.get_theme_stylebox("panel")
	stylebox.bg_color =color
	$MarginContainer/Panel.add_theme_stylebox_override("panel", stylebox)

	$MarginContainer/MarginContainer/HBoxContainer/RichTextLabel.text = text

func updateTextbox():
	var type = SceneControl.Dialog.End if endDialog else SceneControl.Dialog.Start
	var textInfo = SceneControl.textForScene(type)
	if len(textInfo) <= textIndex:
		visible = false
		SceneControl.unpause()
	else:
		var line = textInfo[textIndex]
		setText(line[0], line[1])

func triggerEndDialog():
	textIndex = 0
	endDialog = true
	visible = true
	_startDialog()

func _process(_delta):
	if SceneControl.pauseType() == SceneControl.PauseType.Dialog && Input.is_action_just_pressed(&"B"):
		textIndex += 1
		updateTextbox()
