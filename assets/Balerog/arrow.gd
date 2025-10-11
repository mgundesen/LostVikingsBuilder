extends Hitbox

class_name Arrow

enum ArrowType{basic, fire}
var arrowType = ArrowType.basic

var speed = 8.5

func setType(newType):
	arrowType = newType
	type = Type.colliding if arrowType == ArrowType.basic else Type.fireArrow
	var path = "res://assets/Balerog/arrow.png"
	if arrowType == ArrowType.fire:
		path = "res://assets/Balerog/fire_arrow.png"
	$Sprite2D.texture = load(path)

func _init():
	type = Type.colliding

func _process(_delta):
	if speed < 0:
		$Sprite2D.flip_h = true
	position.x += speed

func _on_body_entered(body: Node2D) -> void:
	if body is not OlafShield:
		queue_free()
