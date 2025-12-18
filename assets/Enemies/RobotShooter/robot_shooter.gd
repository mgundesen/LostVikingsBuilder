extends Enemy

const shootDelay = 0.5
const shootCooldown = 0.9
var longShotCooldown = false

func _ready() -> void:
	health = 2
	hitTypes = [Hitbox.Type.breaking, Hitbox.Type.explode, Hitbox.Type.smartbomb, Hitbox.Type.fireArrow]
	super._ready()

func closeToPlayer():
	var dist = 80 if longShotCooldown else 350
	return PlayerUtil.closeToPlayer(position, dist, Vector2(-1,0) if flip else Vector2(1,0))

func fire():
	longShotCooldown = true
	# can technically give improper state but gives more fun behaviour
	get_tree().create_timer(2.5).timeout.connect(func(): longShotCooldown = false)
	SceneControl.playSound($AudioStreamPlayer2D)
	EnemyUtil.fire(self, flip, -20, Bullet.Type.bullet)

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
