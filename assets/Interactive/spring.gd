extends Area2D

var appliedSpring = false

func _on_body_entered(body: Node2D) -> void:
	if !appliedSpring:
		body.set("springJump", true)
		appliedSpring = true
		$AnimatedSprite2D.play("Pressed")

func _on_body_exited(body: Node2D) -> void:
	appliedSpring = false
	$AnimatedSprite2D.play("Rest")
