extends PlayerBase

const chargeCancelTime = 0.2

const ERIK_MAX_SPEED = 375
const ERIK_WALK_FORCE = 1040

enum Substate {bash, tumble, tumble2}
var subState = Substate.bash

func walkForce():
	return ERIK_WALK_FORCE * (1.0 if is_on_floor() else 1.22)

func walkSpeed():
	if state == State.Inflated:
		return WALK_MAX_SPEED * 0.5
	return ERIK_MAX_SPEED

func stopForce():
	if state == State.AttackMove2:
		return STOP_FORCE * 0.05
	return STOP_FORCE * 1.0 if is_on_floor() else STOP_FORCE * 0.3

func allowJump():
	var regularJump = is_on_floor() and state == State.Free
	var ladderJump = state == State.Ladder
	return Input.is_action_just_pressed(&"B") and (regularJump or ladderJump)

func gravity():
	if Input.is_action_pressed(&"B"):
		return defaultGravity * 0.90
	return defaultGravity

func stateWithInput():
	match state:
		State.AttackMove2:
			return true
		_:
			return super.stateWithInput()

func decideAnimation(yInput, vel):
	if state == State.AttackMove2:
		if subState == Substate.bash:
			$AnimatedSprite2D.play("Dash", 2.1)
		else:
			$AnimatedSprite2D.play("Tumble", 1.3)
	else:
		super.decideAnimation(yInput, vel)

func setState(targetState):
	if state == State.AttackMove2 and (subState == Substate.tumble or subState == Substate.tumble2):
		return
	super.setState(targetState)

func stateWithPhysics():
	match state:
		State.AttackMove2:
			if subState == Substate.bash:
				return true
			else:
				return false
		_:
			return super.stateWithPhysics()

func _physics_process(delta):
	if controlActive and state == State.Free and is_on_floor():
		if Input.is_action_just_pressed(&"Y") and abs(velocity.x) > 200:
			state = State.AttackMove2
			subState = Substate.bash
			get_tree().create_timer(1.2).timeout.connect(func(): setState(State.Free))
	if controlActive and state == State.AttackMove2 and is_on_floor():
		var xInput = Input.get_axis(&"Left", &"Right")
		if xInput < 0.8 and direction == FacingDirection.Right or \
		   xInput > -0.8 and direction == FacingDirection.Left:
			get_tree().create_timer(chargeCancelTime).timeout.connect(func(): setState(State.Free))
			
	if state == State.AttackMove2: 
		if !is_on_floor() and subState == Substate.bash:
			state = State.Free
		elif subState == Substate.bash and is_on_wall():
			wallBonk()
		elif subState == Substate.tumble or subState == Substate.tumble2:
			if subState == Substate.tumble:
				velocity.x = 120 if direction == FacingDirection.Left else -120
			else:
				velocity.x = 0
			velocity.y += gravity() * delta
			move_and_slide()
	super._physics_process(delta)

func wallBonk():
	spawnHitbox(50, Hitbox.Type.breaking)
	subState = Substate.tumble
	play_sfx("bonk")
	velocity.y = -220
	get_tree().create_timer(0.7).timeout.connect(func(): subState = Substate.tumble2)
	# intentional skip of setState to allow exit
	get_tree().create_timer(2.0).timeout.connect(func(): state = State.Free)

func _on_area_2d_area_entered(area: Area2D) -> void:
	if state == State.AttackMove2 and (area is Enemy or area is BreakBlock):
		wallBonk()
	super.on_area_entered(area)
