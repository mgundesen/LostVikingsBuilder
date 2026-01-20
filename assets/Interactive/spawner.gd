extends Node2D

var bubble = load("res://assets/Interactive/bubble.tscn")
var block = load("res://assets/Interactive/fallblock.tscn")

@export var startDelay = 0.0
@export var timeBetween = 7.0
@export var enabled = true
enum Type {bubble, fallblock}
@export var type = Type.bubble
@export var soundOnSpawn = false

func spawnItem():
	var item
	if type == Type.bubble:
		item = bubble.instantiate()
	elif type == Type.fallblock:
		item = block.instantiate()
	if soundOnSpawn:
		SceneControl.playSound($AudioStreamPlayer2D)
	add_child(item)

func withRespawn():
	if enabled:
		spawnItem()
	get_tree().create_timer(timeBetween).timeout.connect(func(): withRespawn())
	
func _ready():
	get_tree().create_timer(startDelay).timeout.connect(func(): withRespawn())

func enable():
	enabled = true
