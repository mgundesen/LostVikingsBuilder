extends ButtonBase

var pressed = false

func buttonPress():
	pressed = true
	SceneControl.playSound($AudioStreamPlayer2D)
	super.buttonPress()

func _process(delta):
	if pressed:
		$AnimatedSprite2D.play("pressed")
	else:
		$AnimatedSprite2D.play("default")
		super._process(delta)
