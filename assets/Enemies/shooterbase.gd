extends Area2D

class_name ShooterBase

var bulletScene = load("res://assets/Enemies/bullet.tscn")

func fire(flip, yOffset = 0):
	var bullet = bulletScene.instantiate()
	var offset = -20 if flip else 20 # fix offset according to image?
	bullet.position += Vector2(offset, yOffset)
	if flip:
		bullet.set("speed", -bullet.get("speed"))
	add_child(bullet)
