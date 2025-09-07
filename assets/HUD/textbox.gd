extends CanvasLayer

var textIndex = 0

func _ready():
	SceneControl.setPause(SceneControl.PauseType.Dialog)
	updateTextbox()

func setText(color, text):
	var stylebox = $MarginContainer/Panel.get_theme_stylebox("panel")
	stylebox.bg_color =color
	$MarginContainer/Panel.add_theme_stylebox_override("panel", stylebox)

	$MarginContainer/MarginContainer/HBoxContainer/RichTextLabel.text = text

func updateTextbox():
	var textInfo = SceneControl.textForScene()
	if len(textInfo) <= textIndex:
		visible = false
		SceneControl.unpause()
	else:
		var line = textInfo[textIndex]
		setText(line[0], line[1])

func _process(_delta):
	if SceneControl.pauseType() == SceneControl.PauseType.Dialog && Input.is_action_just_pressed(&"B"):
		textIndex += 1
		updateTextbox()
