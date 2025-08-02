extends Node2D

@export var itemID = 0

func _ready():
	$Area/ItemSprite.call("setIcon", itemID)
