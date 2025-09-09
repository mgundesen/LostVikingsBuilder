extends Node2D

enum Mode {EndPoints, Circular}
@export var mode = Mode.EndPoints
# EndPoints mode
var start = Vector2()
@export var speed = 2.0
@export var end = Vector2(100,100)
#Circular Mode
@export var radius = 200
var center
var angle = 0

var target = Vector2()
var nextTarget = Vector2()

func _ready():
	if mode == Mode.EndPoints:
		target = end + position
		nextTarget = start + position
	else:
		center = position

func _physics_process(_delta):
	if mode == Mode.EndPoints:
		position += position.direction_to(target) * speed
		if position.distance_to(target) < speed:
			# Why is swap not a thing in gd?
			var temp = target
			target = nextTarget
			nextTarget = temp
	else:
		angle += speed
		var x = center.x + radius * cos(deg_to_rad(angle))
		var y = center.y + radius * sin(deg_to_rad(angle))
		position = Vector2(x,y)
