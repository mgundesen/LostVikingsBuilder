extends Enemy

var onCooldown = false

func turnToPlayer():
	return PlayerUtil.closeToPlayer(position, 300, Vector2(1,0) if flip else Vector2(-1,0))
	
func _process(delta):
	if turnToPlayer():
		doFlip()
	if !onCooldown:
		position.x += -2 if flip else 2
	$Sprite2D.flip_h = flip
	super._process(delta)

func _on_body_entered(body: Node2D) -> void:
	if body is PlayerBase:
		body.takeDamage(PlayerBase.State.HitStun, PlayerBase.State.DeathSkeleton)
		onCooldown = true
		get_tree().create_timer(body.stunTime() + 0.1).timeout.connect(func(): onCooldown = false)
	super._on_body_entered(body)
