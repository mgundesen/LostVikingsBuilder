extends CanvasLayer

func _ready() -> void:
	$ColorRect.color = Color8(0,0,0,255)
	fadein()

func fadein():
	$AnimationPlayer.play("fadein")

func fadeout():
	set_process_mode(Node.PROCESS_MODE_PAUSABLE)
	$AnimationPlayer.play("fadeout")
