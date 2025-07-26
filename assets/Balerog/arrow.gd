extends CharacterBody2D

var speed = 8.5

func _process(_delta):
	if speed < 0:
		$Sprite2D.flip_h = true
	position.x += speed
