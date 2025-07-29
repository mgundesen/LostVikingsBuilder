extends Area2D

class_name Hitbox

var speed = 8.5

func _process(_delta):
	if speed < 0:
		$Sprite2D.flip_h = true
	position.x += speed

func _on_area_entered(area: Area2D) -> void:
	if area is Enemy:
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body is not Shield:
		queue_free()
