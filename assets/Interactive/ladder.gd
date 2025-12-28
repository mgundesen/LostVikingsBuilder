extends Area2D

@export var ladderHeight = 4.0
enum Style{Ship, Candyland, Egypt}
@export var style = Style.Ship

func _ready():
	var path = "res://assets/Interactive/ladder_candy.png"
	if style == Style.Ship:
		path = "res://assets/Interactive/ladder.png"
	elif style == Style.Egypt:
		path = "res://assets/Interactive/ladder_egypt.png"
	$Sprite2D.texture = load(path)
	
	$CollisionShape2D.shape.size.y = ladderHeight * 46 + 1
	$Sprite2D.region_rect.size.y = ladderHeight * 46
	$owplatform.position.y = -(ladderHeight * 46) /2.0

func _on_body_entered(body: Node2D) -> void:
	if body is PlayerBase:
		body.set("ladderAllowed", true)
		body.set("ladderPos", position)
		body.set("ladderHeight", ladderHeight * 46)

func _on_body_exited(body: Node2D) -> void:
	if body is PlayerBase:
		body.set("ladderAllowed", false)
