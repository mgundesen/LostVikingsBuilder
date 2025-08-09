extends "res://player.gd"

const WALK_FORCE = 1050
const WALK_MAX_SPEED = 370

func walkForce():
	return WALK_FORCE * (1.0 if is_on_floor() else 1.2)

func walkSpeed():
	return WALK_MAX_SPEED

func allowJump():
	return Input.is_action_just_pressed(&"B") and (is_on_floor() or state == State.Ladder)
