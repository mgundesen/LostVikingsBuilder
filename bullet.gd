extends Area2D

var speed = -3

func _process(_delta):
	position.x += speed
	
	for body in get_overlapping_bodies():
		if body is PlayerBase:
			body.set("gotHit", true)
			queue_free()
	
