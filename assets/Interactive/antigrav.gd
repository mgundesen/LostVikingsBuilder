extends Area2D

@export var Height = 2
@export var Width = 2
@export var on = false

func _ready():
	$CollisionShape2D.shape.size.x = 46*Width
	$CollisionShape2D.shape.size.y = 46*Height
	$Sprite2D.region_rect.size.x = 46*Width
	$Sprite2D.region_rect.size.y = 46*Height
	$Sprite2D.texture.pause = !on

func _on_body_entered(body: Node2D) -> void:
	if body is PlayerBase and on == true:
		body.enterAntigrav()
	else:
		body.set("inAntigrav", false)

func _on_body_exited(body: Node2D) -> void:
	if body is PlayerBase:
		body.set("inAntigrav", false)

func switch():
	on = !on
	$Sprite2D.texture.pause = !on
	for body in get_overlapping_bodies():
		_on_body_entered(body)
