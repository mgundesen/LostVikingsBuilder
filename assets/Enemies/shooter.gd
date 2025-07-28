extends ShooterBase

@export var flip = false

func _ready():
	$Timer.start()
	if flip:
		$Sprite2D.flip_h = true

func _on_timer_timeout() -> void:
	fire(flip)
