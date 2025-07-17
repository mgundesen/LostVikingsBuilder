extends Node2D

func _process(delta):
	var node = get_node("../Erik")
	if node:
		position = get_node("../Erik").position
