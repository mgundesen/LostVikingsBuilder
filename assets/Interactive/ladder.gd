extends Area2D

@export var ladderHeight = 1

func _ready():
	$CollisionShape2D.shape.size.y = ladderHeight
	$Sprite2D.region_rect.size.y = ladderHeight

func _on_body_entered(body: Node2D) -> void:
	body.set("ladderAllowed", true)
	body.set("ladderPos", position)
	body.set("ladderHeight", ladderHeight)

func _on_body_exited(body: Node2D) -> void:
	body.set("ladderAllowed", false)
