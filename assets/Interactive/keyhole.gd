extends Area2D

class_name KeyHole

@export var type = ItemUtil.Keyhole.red

signal opened

func open():
	opened.emit()
	visible = false

func _process(_delta):
	if visible:
		if type == ItemUtil.Keyhole.red:
			$AnimatedSprite2D.play("red")
		elif type == ItemUtil.Keyhole.blue:
			$AnimatedSprite2D.play("blue")
		elif type == ItemUtil.Keyhole.yellow:
			$AnimatedSprite2D.play("yellow")
