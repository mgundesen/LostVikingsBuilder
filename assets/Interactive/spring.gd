extends Node2D

var appliedSpring = [false, false, false]

func unspring(index):
	appliedSpring[index] = false
	$AnimatedSprite2D.play("Rest")

func _on_body_entered(body: Node2D) -> void:
	
	if body is PlayerBase:
		var index = PlayerUtil.indexForPlayer(body)
		if !appliedSpring[index]:
			body.velocity.y = PlayerBase.SPRING_FORCE
			appliedSpring[index] = true
			SceneControl.playSound($AudioStreamPlayer2D)
			get_tree().create_timer(0.07).timeout.connect(func(): unspring(index))
			$AnimatedSprite2D.play("Pressed")
