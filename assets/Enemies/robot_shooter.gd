extends Enemy

const shootDelay = 0.5
const shootCooldown = 0.9

func _ready() -> void:
	health = 2
	hitTypes = [Hitbox.Type.breaking, Hitbox.Type.explode]

func closeToPlayer():
	return PlayerUtil.closeToPlayer(position, 80, Vector2(-1,0) if flip else Vector2(1,0))

func fire():
	SceneControl.playSound($AudioStreamPlayer2D)
	EnemyUtil.fire(self, flip, -30)

func shouldAttack():
	if closeToPlayer():
		state = State.attack
		$AnimatedSprite2D.set_frame_and_progress(0,0)
		get_tree().create_timer(shootDelay).timeout.connect(fire)
		get_tree().create_timer(shootCooldown).timeout.connect(func(): setState(State.walk))
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
