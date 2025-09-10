extends Node2D

signal activated

var target = Vector2()
var move = false
const speed = 1

func _ready():
	target = position + Vector2(0, 46)

func _physics_process(_delta):
	if move and position.distance_to(target) > speed:
		position += position.direction_to(target) * speed

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Block:
		move = true
		activated.emit()
