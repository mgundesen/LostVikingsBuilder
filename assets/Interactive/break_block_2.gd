extends Node2D

enum Mode {Arrow, Stand}
@export var mode = Mode.Arrow

enum State {default, breaking}
var state = State.default

func _process(_delta: float) -> void:
	if state == State.default:
		$AnimatedSprite2D.play("default")
	elif state == State.breaking:
		$AnimatedSprite2D.play("breaking")

func breakBlock():
	state = State.breaking
	SceneControl.playSound($AudioStreamPlayer2D)
	get_tree().create_timer(0.5).timeout.connect(queue_free)

func _on_area_2d_area_entered(area: Area2D) -> void:
	if mode == Mode.Arrow and area is Arrow:
		area.queue_free()
		breakBlock()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if mode == Mode.Stand and body is PlayerBase:
		get_tree().create_timer(0.5).timeout.connect(breakBlock)
