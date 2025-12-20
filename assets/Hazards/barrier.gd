extends KillArea

@export var blinking = 0.0

func _ready() -> void:
	if blinking > 0:
		blink()

func turnOff():
	enabled = false
	get_tree().create_timer(0.2).timeout.connect(func(): visible = false)

func blink():
	enabled = true
	visible = true
	killInArea()
	get_tree().create_timer(blinking).timeout.connect(blink)
	get_tree().create_timer(0.1).timeout.connect(turnOff)

func _process(_delta: float) -> void:
	if enabled:
		$AnimatedSprite2D.play("default")
	else:
		$AnimatedSprite2D.play("off")

func _turn_off():
	enabled = false
	get_tree().create_timer(0.1).timeout.connect(func(): visible = false)
