extends CharacterBody2D

signal collided

@export var WALK_FORCE = 1050
@export var WALK_MAX_SPEED = 350
const STOP_FORCE = 8000
@export var JUMP_SPEED = 550

@onready var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var animationCounter = 0

func decideAnimation(vel):
	if abs(vel.x) > 0:
		$AnimatedSprite2D.flip_h = velocity.x < 0
	
	if !is_on_floor():
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

func _physics_process(delta):
	# Horizontal movement code. First, get the player's input.
	var appliedWalk = walkForce()
	var walk = appliedWalk * (Input.get_axis(&"Left", &"Right"))
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
	if is_on_floor() and Input.is_action_just_pressed(&"Jump"):
		velocity.y = -JUMP_SPEED
		if abs(velocity.x) == WALK_MAX_SPEED:
			velocity.y *= 1.15
		
	decideAnimation(velocity)

func _on_floor_colided(body: Node2D) -> void:
	pass # Replace with function body.
