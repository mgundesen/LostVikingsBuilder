extends Node2D

const speed = 5
var disabled = false

var target = Vector2()
var nextTarget = Vector2()

func _ready():
	target = position
	nextTarget = position + Vector2(0, 184)

func swapTarget():
	# Why is swap not a thing in gd?
	var temp = target
	target = nextTarget
	nextTarget = temp

func _physics_process(_delta):
	position += position.direction_to(target) * speed
	if position.distance_to(target) < speed:
		swapTarget()

func _on_body_entered(body: Node2D) -> void:
	if body is PlayerBase and disabled == false:
		body.killSquash()
	if body is OlafShield:
		swapTarget()
		disabled = true

func _on_body_exited(body: Node2D) -> void:
	if body is OlafShield:
		disabled = false
