extends CharacterBody2D
class_name PlayerBase

const STOP_FORCE = 8000
const JUMP_SPEED = 550
const SPRING_FORCE = 850

@onready var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# Ladder interface
var ladderAllowed = false
var ladderPos = 0

# Control active interface
var controlActive = false

# Control apply spring jump
var springJump = false

enum State {Free, Ladder}
var state = State.Free

func walkForce():
	return 0
	
func walkSpeed():
	return 0

func allowJump():
	return false

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

func stopForce():
	return STOP_FORCE * (1.0 if is_on_floor() else 0.5)

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
	velocity.y += gravity * delta
	
	
	# Move based on the velocity and snap to the ground.
	move_and_slide()

	if springJump:
		springJump = false
		velocity.y = -SPRING_FORCE

	if triggerJump:
		velocity.y = -JUMP_SPEED
		if abs(velocity.x) == walkSpeed():
			const jumpMultiplier = 1.15
			velocity.y *= jumpMultiplier

func _physics_process(delta):
	var yInput = 0
	var xInput = 0
	var triggerJump = false
	if(controlActive):
		yInput = Input.get_axis(&"Up", &"Down")
		xInput = Input.get_axis(&"Left", &"Right")
		triggerJump = allowJump()
	
	if ladderAllowed and abs(yInput) > 0:
		state = State.Ladder
		velocity = Vector2.ZERO
	elif state == State.Ladder and abs(yInput) < 0.1:
		if abs(xInput) > 0:
			state = State.Free
		if triggerJump:
			state = State.Free
	
	if state == State.Free:
		applyPhysics(xInput, triggerJump, delta)
	elif state == State.Ladder:
		position.x = ladderPos
		position.y += yInput * 2
	decideAnimation(yInput, velocity)
