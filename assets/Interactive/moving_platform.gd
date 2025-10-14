extends Node2D

enum Mode {EndPoints, Circular}
@export var mode = Mode.EndPoints
# EndPoints mode
var start = Vector2()
@export var speed = 2.0
@export var end = Vector2(3,0)
#Circular Mode
@export var radius = 200
var center
var angle = 0

@export var moving = true

var target = Vector2()
var nextTarget = Vector2()

func _ready():
	if mode == Mode.EndPoints:
		target = end * 46 + position
		nextTarget = start * 46 + position
	else:
		center = position

func _startMove():
	moving = true

func toggleMove():
	moving = !moving
	
func swapTarget():
	# Why is swap not a thing in gd?
	var temp = target
	target = nextTarget
	nextTarget = temp

func _physics_process(_delta):
	if not moving:
		return
	if mode == Mode.EndPoints:
		position += position.direction_to(target) * speed
		if position.distance_to(target) < speed:
			swapTarget()
	else:
		angle += speed
		var x = center.x + radius * cos(deg_to_rad(angle))
		var y = center.y + radius * sin(deg_to_rad(angle))
		position = Vector2(x,y)
