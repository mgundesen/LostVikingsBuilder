extends "res://player.gd"

const WALK_FORCE = 1050
const WALK_MAX_SPEED = 370

func walkForce():
	return WALK_FORCE * (1.0 if is_on_floor() else 1.2)

func walkSpeed():
	return WALK_MAX_SPEED

func stopForce():
	if state == State.AttackMove2:
		return STOP_FORCE * 0.01
	return super.stopForce()

func allowJump():
	return Input.is_action_just_pressed(&"B") and (is_on_floor() or state == State.Ladder)

func stateWithInput():
	match state:
		State.AttackMove2:
			return true
		_:
			return super.stateWithInput()

func decideAnimation(yInput, vel):
	if state == State.AttackMove2:
		$AnimatedSprite2D.play("Dash", 2.1)
	else:
		super.decideAnimation(yInput, vel)

func _physics_process(delta):
	if controlActive and state == State.Free and is_on_floor():
		if Input.is_action_just_pressed(&"Y") and abs(velocity.x) > 200:
			state = State.AttackMove2
			# This can falsely lead to exiing another state!
			get_tree().create_timer(1.2).timeout.connect(func(): state = State.Free)
	if controlActive and state == State.AttackMove2 and is_on_floor():
		var xInput = Input.get_axis(&"Left", &"Right")
		if xInput < 0.8 and direction == FacingDirection.Right or xInput > -0.8 and direction == FacingDirection.Left:
			get_tree().create_timer(0.1).timeout.connect(func(): state = State.Free)
	super._physics_process(delta)
