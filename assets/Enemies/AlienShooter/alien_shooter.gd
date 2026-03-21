extends Enemy

var shootCooldown = 0.4

func _ready():
	idleCycle()
	super._ready()

func closeToPlayer():
	return PlayerUtil.closeToPlayer(position, 80, Vector2(-1,0) if flip else Vector2(1,0))
	
func shouldAttack():
	if closeToPlayer():
		state = State.attack
		$AnimatedSprite2D.set_frame_and_progress(0,0)
		get_tree().create_timer(shootCooldown).timeout.connect(func(): EnemyUtil.fire(self, flip, -20))
		get_tree().create_timer(0.8).timeout.connect(func(): idleCycle())
		return true
	return false

func idleCycle():
	state = State.idle
	if !shouldAttack():
		get_tree().create_timer(0.4).timeout.connect(func(): walkCycle())

func walkCycle():
	state = State.walk
	if !shouldAttack():
		get_tree().create_timer(0.4).timeout.connect(func(): idleCycle())

func _physics_process(delta):
	if state == State.walk and !closeToPlayer():
		position.x += -2 if flip else 2

	$AnimatedSprite2D.flip_h = flip
	if state == State.idle:
		$AnimatedSprite2D.play("idle")
	elif state == State.walk:
		$AnimatedSprite2D.play("walk")
	elif state == State.attack:
		$AnimatedSprite2D.play("attack", 0.7)

	super._physics_process(delta)
