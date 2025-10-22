extends Area2D

class_name Bullet

var speed = 6.5
enum Type {laser, bullet}
var type = Type.laser

func setType(newType):
	type = newType
	var path = "res://assets/Enemies/bullet.png"
	if type == Type.bullet:
		path = "res://assets/Enemies/physical_bullet.png"
	$Sprite2D.texture = load(path)

func _process(_delta):
	position.x += speed
	
	for body in get_overlapping_bodies():
		if body is PlayerBase:
			body.bulletHit(position, type)
		if body is Enemy:
			continue
		queue_free()
			
	
