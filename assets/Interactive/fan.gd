extends CharacterBody2D

@export var pushForce = Vector2(-5, 0)
@export var on = true

func _process(_delta: float) -> void:
	if on:
		for body in $Area2D.get_overlapping_bodies():
			if body is PlayerBase and body.state == PlayerBase.State.Inflated:
				body.externalForce = pushForce

	if on:
		$AnimatedSprite2D.play("on")
	else:
		$AnimatedSprite2D.play("off")

func toggle():
	on = !on
