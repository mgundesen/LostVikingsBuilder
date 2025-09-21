extends Node2D

enum State {default, breaking}
var state = State.default

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area is Arrow:
		state = State.breaking
		SceneControl.playSound($AudioStreamPlayer2D)
		area.queue_free()
		get_tree().create_timer(0.7).timeout.connect(func(): queue_free())

func _process(_delta: float) -> void:
	if state == State.default:
		$AnimatedSprite2D.play("default")
	elif state == State.breaking:
		$AnimatedSprite2D.play("breaking")
