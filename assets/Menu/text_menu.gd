extends CanvasLayer

@export var textLabels = ["text"]

var currentIndex = 0
var isActive = true

func labelForIndex(index):
	return find_child(nameForIndex(index), true, false)

func nameForIndex(index):
	return "Label{index}".format({"index": index})

func updateLabels(fontSize = 52):
	var children = $MarginContainer/VBoxContainer.get_children()
	for child in children:
		child.free()
	var count = 0
	for label in textLabels:
		var newLabel = Label.new()
		newLabel.set_name(nameForIndex(count))
		count += 1
		newLabel.add_theme_font_size_override("font_size", fontSize)
		newLabel.add_theme_font_override("font",load("res://assets/Font/troika.otf"))
		newLabel.set_text(label)
		$MarginContainer/VBoxContainer.add_child(newLabel)

func _ready() -> void:
	updateLabels()

func toggle(index, on):
	var onOff = " on" if on else " off"
	labelForIndex(index).set_text(textLabels[index] + onOff)

func _process(_delta):
	var labelPos = find_child(nameForIndex(currentIndex), true, false).position
	$Icon.position = $MarginContainer.position + labelPos + Vector2(-40, 20)
	
	if !isActive:
		return
	
	if Input.is_action_just_pressed(&"Up"):
		if currentIndex == 0:
			currentIndex = textLabels.size() -1
		else:
			currentIndex -= 1
	if Input.is_action_just_pressed(&"Down"):
		if currentIndex == textLabels.size() -1:
			currentIndex = 0
		else:
			currentIndex += 1

func setActive(active):
	isActive = active
	visible = active
