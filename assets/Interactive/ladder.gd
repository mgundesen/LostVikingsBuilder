extends Area2D

@export var ladderHeight = 4.0

func _ready():
	$CollisionShape2D.shape.size.y = ladderHeight * 46 + 1
	$Sprite2D.region_rect.size.y = ladderHeight * 46
	$owplatform.position.y = -(ladderHeight * 46) /2.0

func _on_body_entered(body: Node2D) -> void:
	if body is PlayerBase:
		body.set("ladderAllowed", true)
		body.set("ladderPos", position)
		body.set("ladderHeight", ladderHeight * 46)

func _on_body_exited(body: Node2D) -> void:
	if body is PlayerBase:
		body.set("ladderAllowed", false)
