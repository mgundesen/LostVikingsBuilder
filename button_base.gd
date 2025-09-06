extends Area2D

class_name ButtonBase

signal activated

func buttonPress():
	activated.emit()

func _process(_delta):
	
	if PlayerUtil.getOverlappingActive(self) and Input.is_action_just_pressed(&"A"):
		buttonPress()
	#for area in get_overlapping_areas():
	#	if area is Hitbox and area.type == Hitbox.Type.colliding:
	if CollisionUtil.isColliding(self, [Hitbox.Type.colliding]):
		buttonPress()
