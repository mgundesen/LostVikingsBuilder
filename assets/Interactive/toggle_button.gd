extends ButtonBase

var on = false

func buttonPress():
	on = !on
	super.buttonPress()

func _process(delta):
	super._process(delta)
			
	if on:
		$AnimatedSprite2D.play("on")
	else:
		$AnimatedSprite2D.play("off")
