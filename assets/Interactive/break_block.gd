extends Node2D

var broken = false
var hideOnBreak = false

func spawnNeighbourHitboxes():
	CollisionUtil.spawnHitbox(get_parent(), position + Vector2(46, 0), Hitbox.Type.breaking)
	CollisionUtil.spawnHitbox(get_parent(), position + Vector2(-46, 0), Hitbox.Type.breaking)
	CollisionUtil.spawnHitbox(get_parent(), position + Vector2(0, 46), Hitbox.Type.breaking)
	CollisionUtil.spawnHitbox(get_parent(), position + Vector2(0, -46), Hitbox.Type.breaking)

func _process(_delta):
	if !broken:
		$AnimatedSprite2D.play("default")
	else:
		$AnimatedSprite2D.play("broken")

	var area = $Area2D
	if !broken and CollisionUtil.isColliding(area, [Hitbox.Type.explode, Hitbox.Type.breaking]):
		if hideOnBreak:
			visible = false
		broken = true
		SceneControl.playSound($AudioStreamPlayer2D)
		get_tree().create_timer(0.3).timeout.connect(spawnNeighbourHitboxes)
		$CharacterBody2D.queue_free()
