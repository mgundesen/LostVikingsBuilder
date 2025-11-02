extends Node2D

@export var Width = 2.0
@export var reverse = true

func _ready():
	$CharacterBody2D/CollisionShape2D.shape.size.x = 46*Width
	$CharacterBody2D/Sprite2D.region_rect.size.x = 46*Width
	$Area2D/CollisionShape2D.shape.size.x = 46*Width
	$CharacterBody2D/Sprite2D.texture.speed_scale = 5 if reverse else -5
	$Sprite2DLeft.position.x = -46*Width/2+23
	$Sprite2DLeft.texture.speed_scale = 5 if reverse else -5
	$Sprite2DRight.position.x = 46*Width/2-23
	$Sprite2DRight.texture.speed_scale = 5 if reverse else -5

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is PlayerBase:
		body.onTredmill = true
		body.tredmillSpeed = -1 if reverse else 1

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is PlayerBase:
		body.onTredmill = false
