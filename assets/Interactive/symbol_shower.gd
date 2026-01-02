extends Node2D

var currentKey = 0

func setSprite(index):
	if index > 3 or index < 0:
		return
	var path = "res://assets/Interactive/symbol{index}.png".format({"index": index + 1})
	$Sprite2D.texture = load(path)
	currentKey = index

func increaseSymbol():
	setSprite((currentKey + 1) % 4)
