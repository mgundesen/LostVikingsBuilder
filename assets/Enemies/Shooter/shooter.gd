extends Area2D

@export var flip = false
@export var shootTime = 3.5

func _ready():
	$Timer.start()
	if flip:
		$Sprite2D.flip_h = true
	$Timer.wait_time = shootTime

func _on_timer_timeout() -> void:
	EnemyUtil.fire(self, flip)

func _process(_delta):
	if CollisionUtil.isColliding(self, [Hitbox.Type.explode]):
		queue_free()
