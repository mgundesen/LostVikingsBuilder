extends Area2D

class_name KillArea

var enabled = true

func _on_body_entered(body: Node2D) -> void:
	if enabled and body is PlayerBase:
		body.killShock()
