extends PlayerBase

const SHEILD_FALL_SPEED = 140 # 160-165 is roughly fallspeed in original, slight buff

var raisedSheild = false

func updateSheildCollision():
	var inflatedState = state == State.Inflating or state == State.Inflated
	$Shield/front/CollisionShape2D.disabled = raisedSheild or inflatedState
	$Shield/top/CollisionShape2D.disabled = !raisedSheild or inflatedState

func _ready():
	updateSheildCollision()
	super._ready()
	
func setState(targetState, forceFree = false):
	super.setState(targetState, forceFree)
	updateSheildCollision.call_deferred()

func maybeLimitFall():
	if raisedSheild:
		velocity.y = clamp(velocity.y, -10000, SHEILD_FALL_SPEED)

func _physics_process(delta):
	if controlActive and Input.is_action_just_pressed(&"B") and state == State.Free:
		raisedSheild = !raisedSheild
		updateSheildCollision()
	
	var sheildPos = abs($Shield/front/CollisionShape2D.position.x)
	if direction == FacingDirection.Right:
		$Shield/front/CollisionShape2D.position.x = sheildPos
	else:
		$Shield/front/CollisionShape2D.position.x = -sheildPos
	super._physics_process(delta)

func decideAnimation(yInput, vel):
	$AnimatedSprite2D.flip_h = direction == FacingDirection.Left
	if raisedSheild and state == State.Free:
		if !is_on_floor():
			$AnimatedSprite2D.play("Fall_Sheild")
		elif abs(vel.x) > 0:
			$AnimatedSprite2D.play("Walk_Sheild", 1.5)
		else:
			$AnimatedSprite2D.play("Idle_Sheild")
	else:
		super.decideAnimation(yInput, vel)
