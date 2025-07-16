extends CharacterBody2D

signal collided

const WALK_FORCE = 1050
const WALK_MAX_SPEED = 350
const STOP_FORCE = 8000
const JUMP_SPEED = 550

@onready var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var ladderAllowed = false
var ladderPos = 0

enum State {Free, Ladder}
var state = State.Free

func decideAnimation(yInput, vel):
	if abs(vel.x) > 0:
		$AnimatedSprite2D.flip_h = velocity.x < 0

	if state == State.Ladder:
		if abs(yInput) > 0:
			$AnimatedSprite2D.play("Climb")
		else:
			$AnimatedSprite2D.pause()
	elif !is_on_floor():
		if vel.y > 2:
			$AnimatedSprite2D.play("Fall_Low")
		elif vel.y < 2:
			$AnimatedSprite2D.play("Raise")
		else:
			$AnimatedSprite2D.play("Fall_Low")
	elif abs(vel.x) > 0:
		$AnimatedSprite2D.play("Walk", 1.5)
	else:
		$AnimatedSprite2D.play("Idle")
		
func walkForce():
	return WALK_FORCE * (1.0 if is_on_floor() else 1.2)

func stopForce():
	return STOP_FORCE * (1.0 if is_on_floor() else 0.5)

func applyPhysics(forceJump, xInput, delta):
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
	velocity.x = clamp(velocity.x, -WALK_MAX_SPEED, WALK_MAX_SPEED)

	# Vertical movement code. Apply gravity.
	velocity.y += gravity * delta

	# Move based on the velocity and snap to the ground.
	move_and_slide()

	# Check for jumping. is_on_floor() must be called after movement code.
	if forceJump or (is_on_floor() and Input.is_action_just_pressed(&"Jump")):
		velocity.y = -JUMP_SPEED
		if abs(velocity.x) == WALK_MAX_SPEED:
			const jumpMultiplier = 1.15
			velocity.y *= jumpMultiplier

func _physics_process(delta):
	var yInput = Input.get_axis(&"Up", &"Down")
	var xInput = Input.get_axis(&"Left", &"Right")
	var forceJump = false
	if ladderAllowed and abs(yInput) > 0:
		state = State.Ladder
		velocity = Vector2.ZERO
	elif state == State.Ladder and abs(yInput) < 0.1:
		if abs(xInput) > 0:
			state = State.Free
		if Input.is_action_just_pressed(&"Jump"):
			state = State.Free
			forceJump = true
	
	if state == State.Free:
		applyPhysics(forceJump, xInput, delta)
	elif state == State.Ladder:
		position.x = ladderPos
		position.y += yInput * 2
	decideAnimation(yInput, velocity)
