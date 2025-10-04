extends Node2D

var wallBlockScene = load("res://assets/Interactive/break_block.tscn")
var breakBlockScene = load("res://assets/Interactive/break_block_2.tscn")

enum Type {WallBlock, BreakBlock}
@export var type = Type.WallBlock

@export var nodes = PackedVector2Array()

func spawnBlock(node):
	var block = wallBlockScene.instantiate() if type == Type.WallBlock else breakBlockScene.instantiate()
	add_child(block)
	block.position += node * 46

func _ready():
	for node in nodes:
		spawnBlock(node)
