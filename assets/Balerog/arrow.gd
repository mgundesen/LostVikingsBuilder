extends Hitbox

var speed = 8.5

func _init():
	type = Type.colliding

func _process(_delta):
	if speed < 0:
		$Sprite2D.flip_h = true
	position.x += speed

func _on_body_entered(body: Node2D) -> void:
	if body is not OlafShield:
		queue_free()
