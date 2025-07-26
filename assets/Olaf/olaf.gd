extends "res://player.gd"

const WALK_FORCE = 650
const WALK_MAX_SPEED = 250
const SHEILD_FALL_SPEED = 150

var raisedSheild = false

func updateSheildCollision():
	$Sheild/front/CollisionShape2D.disabled = raisedSheild
	$Sheild/top/CollisionShape2D.disabled = !raisedSheild

func _ready():
	updateSheildCollision()

func walkForce():
	return WALK_FORCE * (1.0 if is_on_floor() else 1.2)

func walkSpeed():
	return WALK_MAX_SPEED

func maybeLimitFall():
	if raisedSheild:
		velocity.y = clamp(velocity.y, -10000, SHEILD_FALL_SPEED)

func _physics_process(delta):
	if controlActive and Input.is_action_just_pressed(&"Jump") and state == State.Free:
		raisedSheild = !raisedSheild
		updateSheildCollision()
	
	var sheildPos = abs($Sheild/front/CollisionShape2D.position.x)
	if velocity.x > 0:
		$Sheild/front/CollisionShape2D.position.x = sheildPos
	elif velocity.x < 0:
		$Sheild/front/CollisionShape2D.position.x = -sheildPos
	super._physics_process(delta)

func decideAnimation(yInput, vel):
	if abs(vel.x) > 0:
		$AnimatedSprite2D.flip_h = velocity.x < 0
	if raisedSheild and state == State.Free:
		if !is_on_floor():
			$AnimatedSprite2D.play("Fall_Sheild")
		elif abs(vel.x) > 0:
			$AnimatedSprite2D.play("Walk_Sheild", 1.5)
		else:
			$AnimatedSprite2D.play("Idle_Sheild")
	else:
		super.decideAnimation(yInput, vel)
