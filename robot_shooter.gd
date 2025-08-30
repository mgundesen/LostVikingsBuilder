extends Enemy

var shootCooldown = 0.4

func _ready() -> void:
	health = 2
	hitTypes = [Hitbox.Type.breaking]

func closeToPlayer():
	return PlayerUtil.closeToPlayer(position, 80, Vector2(-1,0) if flip else Vector2(1,0))
	
func shouldAttack():
	if closeToPlayer():
		state = State.attack
		$AnimatedSprite2D.set_frame_and_progress(0,0)
		get_tree().create_timer(shootCooldown).timeout.connect(func(): EnemyUtil.fire(self, flip, -30))
		get_tree().create_timer(0.8).timeout.connect(func(): setState(State.walk))
		return true
	return false

func _process(delta):
	if state == State.walk:
		if !shouldAttack():
			position.x += -3 if flip else 3

	$AnimatedSprite2D.flip_h = flip
	if state == State.walk:
		$AnimatedSprite2D.play("walk")
	elif state == State.attack:
		$AnimatedSprite2D.play("shoot", 0.7)

	super._process(delta)

func _on_body_entered(body: Node2D) -> void:
	if body is TileMapLayer or body is Door:
		flip = !flip
