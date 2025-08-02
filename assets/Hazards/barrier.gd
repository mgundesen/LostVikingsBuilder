extends KillArea

func _process(delta: float) -> void:
	if enabled:
		$AnimatedSprite2D.play("default")
	else:
		$AnimatedSprite2D.play("off")

func _turn_off():
	enabled = false
	get_tree().create_timer(0.1).timeout.connect(func(): visible = false)
