extends Area2D

class_name ButtonBase

signal activated

func buttonPress():
	activated.emit()

func _process(_delta):
	for body in get_overlapping_bodies():
		if body is PlayerBase and body.get("controlActive") == true and Input.is_action_just_pressed(&"A"):
			buttonPress()
	#for area in get_overlapping_areas():
	#	if area is Hitbox and area.type == Hitbox.Type.colliding:
	if CollisionUtil.isColliding(self, [Hitbox.Type.colliding]):
		buttonPress()
