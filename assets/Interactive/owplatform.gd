extends CharacterBody2D

@export var platformWidth = 137

func _ready() -> void:
	$CollisionShape2D.shape.size.x = platformWidth
