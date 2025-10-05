extends CharacterBody2D

class_name Block

@onready var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var disabled = false

func _physics_process(delta: float) -> void:
	if PlayerUtil.closeToPlayer(position, 46+33, Vector2(-1,0)):
		position.x += 2
	if PlayerUtil.closeToPlayer(position, 46+33, Vector2(1,0)):
		position.x -= 2
	if !disabled:
		velocity.y += gravity * delta
		move_and_slide()
		# Avoid block sticking to a player too much
		if is_on_wall_only():
			position.y += 2

func _on_body_entered(body: Node2D) -> void:
	if body is OlafShield:
		disabled = true
	if body is PlayerBase and disabled == false:
		body.kill(KillArea.Type.Squash)

func _on_body_exited(body: Node2D) -> void:
	if body is OlafShield:
		disabled = false
