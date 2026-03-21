extends Enemy

const SPEED = 170.0
const JUMP_VELOCITY = -450.0

var attackCooldown = false

func _ready() -> void:
	health = 3
	aggroRange = 700
	var frontShield = PlayerUtil.frontShield()
	add_collision_exception_with(frontShield)
	super._ready()

func closeToPlayer():
	return PlayerUtil.closeToPlayer(position, 70, Vector2(-1,0) if flip else Vector2(1,0))

func closeToShield():
	return PlayerUtil.closeToShield(position, 40, Vector2(-1,0) if flip else Vector2(1,0))

func exitAttack():
	setState(State.walk)
	velocity.y = JUMP_VELOCITY
	
func attemptAttack():
	if state == State.attack:
		EnemyUtil.hit(self, flip)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * 0.7 * delta
	if state == State.walk:
		velocity.x = SPEED * (-1.0 if flip else 1.0)
	else:
		velocity.x = 0
	#Handling this here instead of using is agrro for more specific behaviour
	if is_on_floor() and turnToPlayer(): 
		doFlip()
	
	if !attackCooldown and state == State.walk and (closeToPlayer() or closeToShield()):
		attackCooldown = true
		setState(State.attack)
		SceneControl.playSound($AudioStreamPlayer2D)
		get_tree().create_timer(0.15).timeout.connect(attemptAttack)
		get_tree().create_timer(0.7).timeout.connect(exitAttack)
		get_tree().create_timer(1.2).timeout.connect(func(): attackCooldown = false)
	
	$AnimatedSprite2D.flip_h = flip
	if state == State.attack:
		$AnimatedSprite2D.play("attack")
	elif velocity.y > 1:
		$AnimatedSprite2D.play("jump_down")
	elif velocity.y < -1:
		$AnimatedSprite2D.play("jump_up")
	else:
		$AnimatedSprite2D.play("default")

func _on_timer_timeout() -> void:
	if state == State.walk and is_on_floor():
		velocity.y = JUMP_VELOCITY

func _on_body_entered(body: Node2D) -> void:
	if body is not PlayerBase and body is not OlafShield:
		doFlip()
