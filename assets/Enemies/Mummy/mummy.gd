extends Enemy

func _ready() -> void:
	health = 3
	hitTypes = [Hitbox.Type.breaking, Hitbox.Type.explode, Hitbox.Type.smartbomb, Hitbox.Type.fireArrow, Hitbox.Type.sword]
	super._ready()

func closeToPlayer():
	return PlayerUtil.closeToPlayer(position, 50, Vector2(-1,0) if flip else Vector2(1,0))

func closeToShield():
	return PlayerUtil.closeToShield(position, 40, Vector2(-1,0) if flip else Vector2(1,0))

func exitAttack():
	setState(State.walk)
	
func attemptAttack():
	if state == State.attack:
		EnemyUtil.hit(self, flip, 10, 0, 4)

func _physics_process(_delta: float) -> void:
	if state == State.walk and (closeToPlayer() or closeToShield()):
		setState(State.attack)
		get_tree().create_timer(0.2).timeout.connect(attemptAttack)
		get_tree().create_timer(0.7).timeout.connect(exitAttack)
	
	if state == State.walk:
		position.x += -0.8 if flip else 0.8
	
	$AnimatedSprite2D.flip_h = flip
	if state == State.attack:
		$AnimatedSprite2D.play("attack")
	else:
		$AnimatedSprite2D.play("default")
		
