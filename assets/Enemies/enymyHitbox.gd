extends Area2D

var damage = 1

func _ready() -> void:
	get_tree().create_timer(0.5).timeout.connect(queue_free)

func setSize(size):
	$CollisionShape2D.shape.set_size(Vector2(size, size))

func _process(_delta):
	for body in get_overlapping_bodies():
		if body is PlayerBase:
			body.getHit(position, PlayerBase.State.HitStun, PlayerBase.State.DeathSkeleton, damage)
		if body is Enemy:
			continue
		queue_free()
		
