extends Node2D

var blockScene = load("res://assets/Interactive/break_block.tscn")

@export var nodes = PackedVector2Array()

func spawnBlock(node):
	var block = blockScene.instantiate()
	add_child(block)
	block.position += node * 48

func _ready():
	for node in nodes:
		spawnBlock(node)
