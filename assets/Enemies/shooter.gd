extends Area2D

var bulletScene = load("res://assets/Enemies/bullet.tscn")

@export var flip = false

func _ready():
	$Timer.start()
	if flip:
		$Sprite2D.flip_h = true

func _on_timer_timeout() -> void:
	var bullet = bulletScene.instantiate()
	var offset = -40 if flip else 40 # fix offset according to image?
	bullet.position.x += offset
	if flip:
		bullet.set("speed", -bullet.get("speed"))
	add_child(bullet)
