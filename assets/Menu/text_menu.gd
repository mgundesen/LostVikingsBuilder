extends CanvasLayer

@export var textLabels = ["text"]

var currentIndex = 0
var isActive = true

func labelForIndex(index):
	return find_child(nameForIndex(index), true, false)

func nameForIndex(index):
	return "Label{index}".format({"index": index})

func _ready() -> void:
	var count = 0
	for label in textLabels:
		var newLabel = Label.new()
		newLabel.set_name(nameForIndex(count))
		count += 1
		newLabel.add_theme_font_size_override("font_size", 52)
		newLabel.add_theme_font_override("font",load("res://assets/Font/troika.otf"))
		newLabel.set_text(label)
		$MarginContainer/VBoxContainer.add_child(newLabel)

func toggle(index, on):
	var onOff = " on" if on else " off"
	labelForIndex(index).set_text(textLabels[index] + onOff)

func _process(_delta):
	var labelPos = find_child(nameForIndex(currentIndex), true, false).position
	$Icon.position = $MarginContainer.position + labelPos + Vector2(-40, 20)
	
	if !isActive:
		return
	
	if Input.is_action_just_pressed(&"Up") and currentIndex > 0:
		currentIndex -= 1
	if Input.is_action_just_pressed(&"Down") and currentIndex < textLabels.size() -1:
		currentIndex += 1

func setActive(active):
	isActive = active
	visible = active
