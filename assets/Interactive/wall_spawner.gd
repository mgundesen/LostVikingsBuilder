extends Node2D

var wallBlockScene = load("res://assets/Interactive/break_block.tscn")
var breakBlockScene = load("res://assets/Interactive/break_block_2.tscn")
var solidBlockScene = load("res://assets/Interactive/floor.tscn")

enum Type {WallBlock, BreakBlock, BreakBlockWalk, Floor, WallBlockHidden}
@export var type = Type.WallBlock

@export var nodes = PackedVector2Array()
enum SpawnMethod {Instant, Activated}
@export var spawnMethod = SpawnMethod.Instant
var spawned = false

func spawnBlock(node):
	var block
	match type:
		Type.WallBlock, Type.WallBlockHidden:
			block = wallBlockScene.instantiate()
		Type.BreakBlock, Type.BreakBlockWalk:
			block = breakBlockScene.instantiate()
		Type.Floor:
			block = solidBlockScene.instantiate()
	add_child(block)
	if type == Type.BreakBlockWalk:
		block.mode = BreakBlock2.Mode.Stand
	if type == Type.WallBlockHidden:
		block.hideOnBreak = true
	block.position += node * 46

func _ready():
	if spawnMethod == SpawnMethod.Instant:
		for node in nodes:
			spawnBlock(node)

func activate():
	if spawned:
		return
	spawned = true
	
	var delay = 0
	for node in nodes:
		get_tree().create_timer(delay).timeout.connect(func(): spawnBlock(node))
		delay += 0.05
