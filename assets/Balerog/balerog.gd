extends PlayerBase

var arrowScene = load("res://assets/Balerog/arrow.tscn")

enum SwingState {Overhead, Horizontal}
var swingState
var rng = RandomNumberGenerator.new()

enum AttackState {Ready, Idle, Shoot}
var subState = AttackState.Ready
var arrowType = Arrow.ArrowType.basic

const arrowOffset = 40
const swordOffset = 50

func spawnArrow():
	var arrow = arrowScene.instantiate()
	arrow.setType(arrowType)
	if direction == FacingDirection.Left:
		arrow.set("speed", -arrow.get("speed"))
	owner.add_child(arrow)
	arrow.transform = transform
	var offset = -arrowOffset if direction == FacingDirection.Left else arrowOffset
	#-7 is not visually pleasing with the bow position but allows the shot to go over a single block
	arrow.position += Vector2(offset, -7)

func canUseFireArrow():
	arrowType = Arrow.ArrowType.fire
	return true

func decideAnimation(yInput, vel):
	$AnimatedSprite2D.flip_h = direction == FacingDirection.Left
	if state == State.AttackMove:
		if swingState == SwingState.Overhead:
			$AnimatedSprite2D.play("Swing", 2.3)
		else:
			$AnimatedSprite2D.play("Swing2", 1.8)
	elif state == State.AttackMove2:
		if subState == AttackState.Ready:
			$AnimatedSprite2D.play("Shoot_Ready", 2.3)
		if subState == AttackState.Idle:
			$AnimatedSprite2D.play("Shoot_Idle", 2.3)
		if subState == AttackState.Shoot:
			$AnimatedSprite2D.play("Shoot", 2.3)
	else:
		super.decideAnimation(yInput, vel)

func _physics_process(delta):
	if controlActive and state == State.Free and is_on_floor():
		if Input.is_action_just_pressed(&"B"):
			velocity.x = 0
			state = State.AttackMove
			swingState = SwingState.Horizontal if rng.randi_range(0,1) == 0 else SwingState.Overhead
			spawnHitbox(swordOffset, Hitbox.Type.sword)
			play_sfx("sword1")
			get_tree().create_timer(0.5).timeout.connect(func(): state = State.Free)
		if Input.is_action_pressed(&"Y"):
			velocity.x = 0
			state = State.AttackMove2
			subState = AttackState.Ready
			get_tree().create_timer(0.5).timeout.connect(func(): subState = AttackState.Idle)
	if state == State.AttackMove2 and subState == AttackState.Idle:
		if !Input.is_action_pressed(&"Y"):
			subState = AttackState.Shoot
			play_sfx("bow")
			spawnArrow()
			get_tree().create_timer(0.5).timeout.connect(func(): state = State.Free)
			
	super._physics_process(delta)
