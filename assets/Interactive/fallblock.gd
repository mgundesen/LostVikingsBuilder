extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body is PlayerBase:
		EnemyUtil.simpleHit(self)
		queue_free()
	if body is Tiles:
		queue_free()

func _process(_delta: float) -> void:
	position.y += 7
