extends "res://player.gd"

var arrowScene = load("res://assets/Balerog/arrow.tscn")

const WALK_FORCE = 650
const WALK_MAX_SPEED = 250

func spawnArrow():
	var arrow = arrowScene.instantiate()
	var offset = -40 if direction == FacingDirection.Left else 40 # fix offset according to image?
	arrow.position.x += offset
	if direction == FacingDirection.Left:
		arrow.set("speed", -arrow.get("speed"))
	owner.add_child(arrow)
	arrow.transform = transform

func walkForce():
	return WALK_FORCE * (1.0 if is_on_floor() else 1.2)

func walkSpeed():
	return WALK_MAX_SPEED

func decideAnimation(yInput, vel):
	$AnimatedSprite2D.flip_h = direction == FacingDirection.Left
	if state == State.AttackMove2:
			$AnimatedSprite2D.play("Shoot", 2.3)
	else:
		super.decideAnimation(yInput, vel)

func _physics_process(delta):
	if controlActive and state == State.Free and is_on_floor():
		if Input.is_action_just_pressed(&"Y"):
			velocity.x = 0
			state = State.AttackMove2
			get_tree().create_timer(0.5).timeout.connect(func(): spawnArrow())
			get_tree().create_timer(1.0).timeout.connect(func(): state = State.Free)
			
	super._physics_process(delta)
