extends CharacterBody2D

class_name Block

@onready var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta: float) -> void:
	velocity.y += gravity * delta
	
	if PlayerUtil.closeToPlayer(position, 46+33, Vector2(-1,0)):
		position.x += 2
	if PlayerUtil.closeToPlayer(position, 46+33, Vector2(1,0)):
		position.x -= 2
	move_and_slide()
