extends Node2D

var bubble = load("res://assets/Interactive/bubble.tscn")

@export var startDelay = 0.0
@export var timeBetween = 7.0

func spawnBubble():
	var block = bubble.instantiate()
	add_child(block)

func withRespawn():
	spawnBubble()
	get_tree().create_timer(timeBetween).timeout.connect(func(): withRespawn())
	
func _ready():
	get_tree().create_timer(startDelay).timeout.connect(func(): withRespawn())
		
