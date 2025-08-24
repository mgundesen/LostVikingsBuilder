extends Node2D

@export var itemID = ItemUtil.Item.none

func _ready():
	$Area/ItemSprite.call("setIcon", itemID)

func _on_area_body_entered(body: Node2D) -> void:
	if body is PlayerBase and body.call("addItem", itemID):
		queue_free()
