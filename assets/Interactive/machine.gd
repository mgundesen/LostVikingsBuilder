extends Area2D

class_name Machine

signal activated

var broken = false

func destroy():
	activated.emit()
	broken = true
	SceneControl.playSound($AudioStreamPlayer2D)

func _process(_delta):
	if broken:
		$AnimatedSprite2D.play("broken")		
	else:
		$AnimatedSprite2D.play("default")		

	if CollisionUtil.isColliding(self, [Hitbox.Type.explode]):
		destroy()
