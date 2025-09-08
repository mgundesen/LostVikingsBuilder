extends Area2D

var speed = 6.5

func _process(_delta):
	position.x += speed
	
	for body in get_overlapping_bodies():
		if body is PlayerBase:
			body.bulletHit(position)
		queue_free()
			
	
