extends "res://assets/player.gd"

const WALK_FORCE = 650
const WALK_MAX_SPEED = 150

func walkForce():
	return WALK_FORCE * (1.0 if is_on_floor() else 1.2)

func walkSpeed():
	return WALK_MAX_SPEED
