extends CharacterBody2D
class_name PlayerBase

const STOP_FORCE = 8000
const JUMP_SPEED = 550
const SPRING_FORCE = 850
const FALL_DAMAGE_LIMIT = 850
const CLIMB_SPEED = 3

var bombScene = load("res://assets/Items/bomb.tscn")

@onready var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# Ladder interface
var ladderAllowed = false
var ladderPos = Vector2()
var ladderHeight = 0

# Kill interface
var killShock = false

# Hit interface
var gotHit = false

# Control active interface
var controlActive = false

# Control apply spring jump
var springJump = false

var inAntigrav = false

var playerHealth = 3
var itemSlot =  0
var items = [0,0,0,0]

enum State {Free, AttackMove, AttackMove2, Ladder, HitStun, FallStun, FallDeath, ShockDeath, Dead}
var state = State.Free
enum FacingDirection {Left, Right}
var direction = FacingDirection.Right

func addItem(id):
	for index in range(4):
		if items[index] == 0:
			items[index] = id
			if items[itemSlot] == 0:
				itemSlot = index
			return true
	return false

func useItem():
	match items[itemSlot]:
		ItemUtil.Item.none:
			return
		ItemUtil.Item.raddish:
			if playerHealth < 3:
				playerHealth += 1
		ItemUtil.Item.bomb:
			var bomb = bombScene.instantiate()
			owner.add_child(bomb)
			bomb.transform = transform
	
	items[itemSlot] = ItemUtil.Item.none
	itemSlot = (itemSlot + 1) %4

func stateWithPhysics():
	match state:
		State.Free:
			return true
		State.AttackMove:
			return true
		State.AttackMove2:
			return true
		State.FallStun:
			return true
		_:
			return false

func stateWithInput():
	match state:
		State.Free:
			return true
		State.Ladder:
			return true
		_:
			return false

func walkForce():
	return 0
	
func walkSpeed():
	return 0

func allowJump():
	return false

func decideAnimation(yInput, vel):
	$AnimatedSprite2D.flip_h = direction == FacingDirection.Left
	if state == State.FallDeath:
		$AnimatedSprite2D.play("Death_Fall")
	elif state == State.FallStun:
		$AnimatedSprite2D.play("Fall_Stun")
	elif state == State.ShockDeath:
		$AnimatedSprite2D.play("Death_Shock")
	elif state == State.HitStun:
		$AnimatedSprite2D.play("Hit")
	elif state == State.Ladder:
		if abs(yInput) > 0:
			$AnimatedSprite2D.play("Climb")
		else:
			$AnimatedSprite2D.pause()
	elif !is_on_floor():
		if vel.y > FALL_DAMAGE_LIMIT: # this should maybe be delta indifferent
			$AnimatedSprite2D.play("Fall_Full")
		elif vel.y > 2:
			$AnimatedSprite2D.play("Fall_Low")
		elif vel.y < 2:
			$AnimatedSprite2D.play("Raise")
		else:
			$AnimatedSprite2D.play("Fall_Low")
	elif abs(vel.x) > 0:
		$AnimatedSprite2D.play("Walk", 1.5)
	else:
		$AnimatedSprite2D.play("Idle")

func stopForce():
	return STOP_FORCE * (1.0 if is_on_floor() else 0.07)

func maybeLimitFall():
	return

func killPlayer():
	state = State.Dead
	for i in range(4):
		items[i] = ItemUtil.Item.none
	visible = false
	position = Vector2(-100000, -100000) # Move the hitboxes away
	
func stunTime():
	if state == State.FallStun:
		return 2.0
	else:
		return 0.7

func setState(targetState):
	if(state == State.FallDeath or state == State.ShockDeath):
		return
	state = targetState

func takeDamage(stunState, deathState, amount = 1):
	playerHealth -= amount
	if playerHealth > 0:
		state = stunState
		get_tree().create_timer(stunTime()).timeout.connect(func(): setState(State.Free))
	else:
		state = deathState
		get_tree().create_timer(1.0).timeout.connect(func(): killPlayer())

func applyPhysics(xInput, triggerJump, delta):
	# Horizontal movement code. First, get the player's input.
	var appliedWalk = walkForce()
	var walk = appliedWalk * xInput
	# Slow down the player if they're not trying to move.
	if abs(walk) < appliedWalk * 0.2:
		# The velocity, slowed down a bit, and then reassigned.
		velocity.x = move_toward(velocity.x, 0, stopForce() * delta)
	else:
		velocity.x += walk * delta
	# Clamp to the maximum horizontal movement speed.
	velocity.x = clamp(velocity.x, -walkSpeed(), walkSpeed())

	# Vertical movement code. Apply gravity.
	if inAntigrav:
		velocity.y -= gravity * 0.1 * delta
	else:
		velocity.y += gravity * delta
		maybeLimitFall()
	
	var canTakeFallDamage = velocity.y > FALL_DAMAGE_LIMIT
	# Move based on the velocity and snap to the ground.
	move_and_slide()
	if get_slide_collision_count() > 0:
		# fix some collision are ok
		if canTakeFallDamage and is_on_floor():
			takeDamage(State.FallStun, State.FallDeath)

	if springJump:
		springJump = false
		velocity.y = -SPRING_FORCE

	if triggerJump:
		velocity.y = -JUMP_SPEED
		if abs(velocity.x) == walkSpeed():
			const jumpMultiplier = 1.15
			velocity.y *= jumpMultiplier

func ladderTop():
	return ladderPos.y - ladderHeight / 2.0 - $CollisionShape2D.shape.size.y / 2.0 * scale.y

func ladderBottom():
	return ladderPos.y + ladderHeight / 2.0 - $CollisionShape2D.shape.size.y / 2.0 * scale.y

func validLadderInput(yInput):
	if !ladderAllowed or abs(yInput) < 0.1:
		return false
	if yInput < 0: #Going up
		if position.y < ladderTop():
			return false
	if yInput > 0: #Going down
		if position.y > ladderBottom():
			return false
	return true

func _physics_process(delta):
	var yInput = 0
	var xInput = 0
	var triggerJump = false
	if controlActive:
		if stateWithInput():
			yInput = Input.get_axis(&"Up", &"Down")
			xInput = Input.get_axis(&"Left", &"Right")
			triggerJump = allowJump()
		if Input.is_action_just_pressed(&"X"):
			useItem()
	
	if gotHit:
		gotHit = false
		velocity.y = 0
		takeDamage(State.HitStun, State.ShockDeath)
	
	if killShock:
		killShock = false
		takeDamage(State.ShockDeath, State.ShockDeath, 4)
	
	if validLadderInput(yInput) and state == State.Free and abs(yInput) > 0:
		state = State.Ladder
		velocity = Vector2.ZERO
	elif state == State.Ladder and abs(yInput) < 0.1:
		if abs(xInput) > 0 or triggerJump:
			state = State.Free
	if springJump:
		state = State.Free
				
	if state == State.HitStun:
		velocity.x = -40
		velocity.y += gravity * delta
		move_and_slide()
	if stateWithPhysics():
		applyPhysics(xInput, triggerJump, delta)
	elif state == State.Ladder:
		position.x = ladderPos.x
		position.y += yInput * CLIMB_SPEED
		if position.y < ladderTop() or position.y > ladderBottom():
			state = State.Free
			
	if velocity.x > 0:
		direction = FacingDirection.Right
	elif velocity.x < 0:
		direction = FacingDirection.Left
	decideAnimation(yInput, velocity)
