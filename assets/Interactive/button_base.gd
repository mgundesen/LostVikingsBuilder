extends Area2D

class_name ButtonBase

@export var buttonCooldown = 0.0
var isOnCooldown = false
signal activated

func buttonPress():
	if !isOnCooldown:
		isOnCooldown = true
		get_tree().create_timer(buttonCooldown).timeout.connect(func(): isOnCooldown = false)
		activated.emit()

func _process(_delta):
	
	if PlayerUtil.getOverlappingActive(self) and Input.is_action_just_pressed(&"A"):
		buttonPress()
	#for area in get_overlapping_areas():
	#	if area is Hitbox and area.type == Hitbox.Type.colliding:
	if CollisionUtil.isColliding(self, [Hitbox.Type.colliding]):
		buttonPress()
