extends CanvasLayer

@export var textLabels = ["text"]

var currentIndex = 2

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
		

func _process(_delta):
	var labelPos = find_child(nameForIndex(currentIndex), true, false).position
	$Icon.position = $MarginContainer.position + labelPos + Vector2(-40, 20)
