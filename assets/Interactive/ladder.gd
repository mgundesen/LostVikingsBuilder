extends Area2D

@export var ladderHeight = 1

func _ready():
	$CollisionShape2D.shape.size.y = ladderHeight + 1
	$Sprite2D.region_rect.size.y = ladderHeight
	$owplatform.position.y = -ladderHeight/2

func _on_body_entered(body: Node2D) -> void:
	if body is PlayerBase:
		body.set("ladderAllowed", true)
		body.set("ladderPos", position)
		body.set("ladderHeight", ladderHeight)

func _on_body_exited(body: Node2D) -> void:
	if body is PlayerBase:
		body.set("ladderAllowed", false)
