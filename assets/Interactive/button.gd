extends Area2D

class_name GameButton

var pressed = false
signal activated

func buttonPress():
	pressed = true
	activated.emit()
	get_tree().create_timer(0.1).timeout.connect(func(): pressed = false)

func _process(_delta):
	for body in get_overlapping_bodies():
		if body is PlayerBase and body.get("controlActive") == true and Input.is_action_just_pressed(&"A"):
			buttonPress()
	for area in get_overlapping_areas():
		if area is Hitbox and area.type == Hitbox.Type.colliding:
			buttonPress()
			area.queue_free()
			
	if pressed:
		$AnimatedSprite2D.play("pressed")
	else:
		$AnimatedSprite2D.play("default")
