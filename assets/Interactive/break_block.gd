extends Node2D

var broken = false

func _process(_delta):
	if !broken:
		$AnimatedSprite2D.play("default")
	else:
		$AnimatedSprite2D.play("broken")

	var area = $Area2D
	if !broken and CollisionUtil.isColliding(area, [Hitbox.Type.explode, Hitbox.Type.breaking]):
		broken = true
		$CharacterBody2D.queue_free()
