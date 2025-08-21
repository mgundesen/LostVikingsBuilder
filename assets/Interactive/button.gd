extends ButtonBase

var pressed = false

func buttonPress():
	pressed = true
	get_tree().create_timer(0.1).timeout.connect(func(): pressed = false)
	super.buttonPress()

func _process(delta):
	super._process(delta)
			
	if pressed:
		$AnimatedSprite2D.play("pressed")
	else:
		$AnimatedSprite2D.play("default")
