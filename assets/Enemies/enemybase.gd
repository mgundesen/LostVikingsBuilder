extends Area2D

class_name Enemy

enum State{walk, idle, attack, hurt}
var state = State.walk

@export var flip = false 
var health = 1
var hitTypes = []

func setState(newState):
	if state != State.hurt:
		state = newState

func _process(_delta):
	if state == State.hurt:
		position.x += 1.5 if flip else -1.5
	
	if CollisionUtil.isColliding(self, hitTypes):
		health -= 1
		if health == 0:
			# play death animation
			queue_free()
		else:
			state = State.hurt
			get_tree().create_timer(0.5).timeout.connect(func(): state = State.walk)
