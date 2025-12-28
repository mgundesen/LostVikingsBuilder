extends Node2D

@export var nodes = PackedVector2Array()
@export var startNode = 0
@export var speed = 3
@export var enabled = true
enum Style{Ship, Candyland, Egypt}
@export var style = Style.Ship

var previousTarget = 0
var targetIndex = 0

func _ready():
	for i in range(nodes.size()):
		nodes[i] = nodes[i] * 46 + position
	targetIndex = startNode
	var target = nodes[targetIndex]
	position = target
	var path = "res://assets/Interactive/elevator.png" # Candyland elevator is ugly as heck
	if style == Style.Egypt:
		path = "res://assets/Interactive/elevator_egypt.png"
	$Sprite2D.texture = load(path)

func isAtTarget():
	var target = nodes[targetIndex]
	return position.distance_to(target) < speed

func _physics_process(_delta):
	var target = nodes[targetIndex]
	var atTarget = isAtTarget()
	if atTarget:
		position = target
		$AudioStreamPlayer2D.stop()
	else:
		position += position.direction_to(target) * speed

	# Maybe force move the player for more LV1 experience?

	if enabled and PlayerUtil.getOverlappingActive($Area2D):
		if targetIndex > 0 and Input.is_action_pressed(&"Up") :
			if atTarget or previousTarget == targetIndex - 1:
				previousTarget = targetIndex
				targetIndex -= 1
				SceneControl.playSound($AudioStreamPlayer2D)
		if targetIndex < nodes.size() - 1 and Input.is_action_pressed(&"Down"):
			if atTarget or previousTarget == targetIndex + 1:
				previousTarget = targetIndex
				targetIndex += 1
				SceneControl.playSound($AudioStreamPlayer2D)

func enable():
	enabled = true

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is PlayerBase:
		body.onElevator = self

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is PlayerBase:
		body.onElevator = null
