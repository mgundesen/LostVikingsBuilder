extends Area2D

class_name KeyHole

@export var type = ItemUtil.Keyhole.red
var isOpen = false

signal opened

func open():
	isOpen = true
	opened.emit()
	if type != ItemUtil.Keyhole.machine:
		visible = false

func _process(_delta):
	if visible:
		if type == ItemUtil.Keyhole.red:
			$AnimatedSprite2D.play("red")
		elif type == ItemUtil.Keyhole.blue:
			$AnimatedSprite2D.play("blue")
		elif type == ItemUtil.Keyhole.yellow:
			$AnimatedSprite2D.play("yellow")
		elif type == ItemUtil.Keyhole.machine and !isOpen:
			$AnimatedSprite2D.play("machine")
		elif type == ItemUtil.Keyhole.machine and isOpen:
			$AnimatedSprite2D.play("machine_open")
