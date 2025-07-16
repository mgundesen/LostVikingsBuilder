extends Area2D

func _on_body_entered(body: Node2D) -> void:
	body.set("ladderAllowed", true)
	body.set("ladderPos", position.x)

func _on_body_exited(body: Node2D) -> void:
	body.set("ladderAllowed", false)
