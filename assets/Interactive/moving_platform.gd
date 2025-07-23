extends Node2D

var start = Vector2()
@export var end = Vector2(100,100)
@export var speed = 2

var target = Vector2()
var nextTarget = Vector2()

func _ready():
	target = end + position
	nextTarget = start + position

func _process(_delta):
	position += position.direction_to(target) * speed
	if position.distance_to(target) < speed:
		# Why is swap not a thing in gd?
		var temp = target
		target = nextTarget
		nextTarget = temp
