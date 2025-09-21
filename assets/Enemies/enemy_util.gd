extends Node

var bulletScene = load("res://assets/Enemies/bullet.tscn")

func fire(origin, flip, yOffset = 0):
	var bullet = bulletScene.instantiate()
	if flip:
		bullet.set("speed", -bullet.get("speed"))
	origin.get_parent().add_child(bullet)
	bullet.position = origin.position
	var offset = -20 if flip else 20 # fix offset according to image?
	bullet.position += Vector2(offset, yOffset)
