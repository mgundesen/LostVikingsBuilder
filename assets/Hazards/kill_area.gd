extends Area2D

class_name KillArea

enum Type {Shock, Drown, Squash, Spikes}
var type = Type.Shock

var enabled = true

func _on_body_entered(body: Node2D) -> void:
	if enabled and body is PlayerBase:
		body.kill(type)
