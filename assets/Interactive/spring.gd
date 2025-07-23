extends Area2D

var appliedSpring = false

func unspring():
	appliedSpring = false
	$AnimatedSprite2D.play("Rest")

func _on_body_entered(body: Node2D) -> void:
	if !appliedSpring:
		body.set("springJump", true)
		appliedSpring = true
		get_tree().create_timer(0.07).timeout.connect(func(): unspring())
		$AnimatedSprite2D.play("Pressed")
