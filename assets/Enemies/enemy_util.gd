extends Node

var bulletScene = load("res://assets/Enemies/bullet.tscn")
var hitboxScene = load("res://assets/Enemies/enemy_hitbox.tscn")

func fire(origin, flip, yOffset = 0, type = Bullet.Type.laser):
	var bullet = bulletScene.instantiate()
	bullet.setType(type)
	if flip:
		bullet.set("speed", -bullet.get("speed"))
	origin.get_parent().add_child(bullet)
	bullet.position = origin.position
	var offset = -20 if flip else 20 # fix offset according to image?
	bullet.position += Vector2(offset, yOffset)

func hitImpl(origin: Node2D, size, xOffset, yOffset, damage):
	var hitbox = hitboxScene.instantiate()
	hitbox.damage = damage
	hitbox.setSize(size)
	hitbox.position = origin.position
	hitbox.position += Vector2(xOffset, yOffset)
	origin.get_parent().call_deferred("add_child", hitbox)

func hit(origin: Node2D, flip: bool, size = 20, yOffset = 0, damage = 1):
	var offset = -40 if flip else 40 # fix offset according to image?
	hitImpl(origin, size, offset, yOffset, damage)

func simpleHit(origin: Node2D):
	hitImpl(origin, 50, 0, 0, 1)
