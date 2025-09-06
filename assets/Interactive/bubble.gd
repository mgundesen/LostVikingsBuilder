extends Node2D

enum State {default, breaking}
var state = State.default

@export var speed = 1.0
@export var aliveTime = 5.0

func _stratBreak():
	state = State.breaking
	get_tree().create_timer(0.3).timeout.connect(func(): SceneControl.playSound($AudioStreamPlayer2D))
	get_tree().create_timer(0.4).timeout.connect(func(): queue_free())

func _ready() -> void:
	get_tree().create_timer(aliveTime).timeout.connect(_stratBreak)

func _process(_delta: float) -> void:
	position.y -= speed

	if state == State.default:
		$AnimatedSprite2D.play("default")
	if state == State.breaking:
		$AnimatedSprite2D.play("breaking", 3)
