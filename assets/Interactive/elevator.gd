extends Node2D

@export var nodes = PackedVector2Array()
@export var speed = 3

var previousTarget = 0
var targetIndex = 0

func _ready():
	for i in range(nodes.size()):
		nodes[i] = nodes[i] * 46 + position

func _physics_process(_delta):
	var target = nodes[targetIndex]
	var atTarget = position.distance_to(target) < speed
	if atTarget:
		position = target
	else:
		position += position.direction_to(target) * speed
	# Maybe force move the player for more LV1 experience?

	# This code allows to buffer multiple index changes (not intended)
	for body in $Area2D.get_overlapping_bodies():
		if body is PlayerBase:
			if body.get("controlActive") == true:
				if targetIndex > 0 and Input.is_action_pressed(&"Up") :
					if atTarget or previousTarget == targetIndex - 1:
						previousTarget = targetIndex
						targetIndex -= 1
				if targetIndex < nodes.size() - 1 and Input.is_action_pressed(&"Down"):
					if atTarget or previousTarget == targetIndex + 1:
						previousTarget = targetIndex
						targetIndex += 1
