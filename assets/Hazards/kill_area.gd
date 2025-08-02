extends Area2D

class_name KillArea

var enabled = true

func _on_body_entered(body: Node2D) -> void:
	if enabled:
		body.set("killShock", true)
