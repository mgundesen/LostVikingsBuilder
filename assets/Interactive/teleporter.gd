extends Area2D

@export var offset = Vector2(0,0)

var teleportTarget

func _ready():
	teleportTarget = position + offset * 46
	
func _on_body_entered(body: Node2D) -> void:
	if body is PlayerBase:
		body.teleportAllowed = true
		body.teleportTarget = teleportTarget
