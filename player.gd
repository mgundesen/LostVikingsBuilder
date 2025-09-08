extends CharacterBody2D
class_name PlayerBase

const STOP_FORCE = 1600
const WALK_FORCE = 650
const WALK_MAX_SPEED = 250
const JUMP_SPEED = 550
const SPRING_FORCE = 850
const FALL_DAMAGE_LIMIT = 850
const CLIMB_SPEED = 3

const bombScene = preload("res://assets/Items/bomb.tscn")
const hitboxScene = preload("res://assets/Hitbox/hitbox.tscn")

@onready var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# Ladder interface
var ladderAllowed = false
var ladderPos = Vector2()
var ladderHeight = 0

# Kill interface
var killShock = false

# Control active interface
var controlActive = false

# Control apply spring jump
var springJump = false

var inAntigrav = false

var playerHealth = 3
var itemSlot =  0
var items = [0,0,0,0]

enum State {Free, AttackMove, AttackMove2, Ladder, Inflating, Inflated,
			HitStun, FallStun, FallDeath, ShockDeath, Dead}
var state = State.Free
enum FacingDirection {Left, Right}
var direction = FacingDirection.Right

@onready var sfx = $AudioStreamPlayer2D

# Preload sound effects
const sounds = {
	"landing": preload("res://assets/PlayerSounds/landing.mp3"),
	"bonk": preload("res://assets/PlayerSounds/bonk.mp3"),
	"itemPickup": preload("res://assets/PlayerSounds/item_pickup.mp3"),
	"itemUse": preload("res://assets/PlayerSounds/item_use.mp3"),
	"itemUseFood": preload("res://assets/PlayerSounds/item_use_burb.mp3"),
	"itemFail": preload("res://assets/PlayerSounds/item_fail.mp3"),
	"hurt": preload("res://assets/PlayerSounds/hurt.mp3"),
	"deathShock": preload("res://assets/PlayerSounds/death_shock.mp3"),
	"bow": preload("res://assets/PlayerSounds/bow.mp3"),
	"sword1": preload("res://assets/PlayerSounds/sword1.mp3"),
	"sword2": preload("res://assets/PlayerSounds/sword2.mp3")	
}

func play_sfx(soundName: String):
	sfx.stream = sounds[soundName]
	SceneControl.playSound(sfx)

func _ready():
	set_platform_on_leave(PLATFORM_ON_LEAVE_DO_NOTHING)

func facingDirected(offset):
	return -offset if direction == FacingDirection.Left else offset

func addItem(id, withSound = true):
	if withSound:
		play_sfx("itemPickup")
	for index in range(4):
		if items[index] == 0:
			items[index] = id
			if items[itemSlot] == 0:
				itemSlot = index
			return true
	return false

func useKey(type):
	var areaNode = find_child("Area2D", false)
	for area in areaNode.get_overlapping_areas():
		if area is KeyHole and area.type == type:
			area.call("open")
			return true
	return false

func useItem():
	var sound = "itemUse"
	match items[itemSlot]:
		ItemUtil.Item.none:
			return false
		ItemUtil.Item.raddish:
			if playerHealth < 3:
				playerHealth += 1
				sound = "itemUseFood"
			else:
				return false
		ItemUtil.Item.bomb:
			var bomb = bombScene.instantiate()
			owner.add_child(bomb)
			bomb.transform = transform
		ItemUtil.Item.keyBlue:
			if !useKey(ItemUtil.Keyhole.blue):
				return false
		ItemUtil.Item.keyYellow:
			if !useKey(ItemUtil.Keyhole.yellow):
				return false
		ItemUtil.Item.keyRed:
			if !useKey(ItemUtil.Keyhole.red):
				return false
	
	items[itemSlot] = ItemUtil.Item.none
	itemSlot = (itemSlot + 1) %4
	play_sfx(sound)
	return true

func _implSpawnHitbox(offset, type):
	var hitboxPos = position
	hitboxPos.x += facingDirected(offset)
	CollisionUtil.spawnHitbox(owner, hitboxPos, type)
	
func spawnHitbox(offset, type = Hitbox.Type.basic):
	call_deferred("_implSpawnHitbox", offset, type)	

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
		State.Inflated:
			return true
		_:
			return false

func stateWithInput():
	match state:
		State.Free:
			return true
		State.Ladder:
			return true
		State.Inflated:
			return true
		_:
			return false

func walkForce():
	return WALK_FORCE * (1.0 if is_on_floor() else 1.4)
	
func walkSpeed():
	if state == State.Inflated:
		return WALK_MAX_SPEED * 0.5
	return WALK_MAX_SPEED

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
	elif state == State.Inflating:
		$AnimatedSprite2D.play("Inflate")
	elif state == State.Inflated:
		$AnimatedSprite2D.play("Inflated")
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
	if targetState == State.Inflating:
		get_tree().create_timer(0.3).timeout.connect(func(): setState(State.Inflated))
	if targetState == State.Inflated:
		get_tree().create_timer(5).timeout.connect(func(): setState(State.Free))

func takeDamage(stunState, deathState, amount = 1):
	playerHealth -= amount
	play_sfx("hurt")
	if playerHealth > 0:
		state = stunState
		get_tree().create_timer(stunTime()).timeout.connect(func(): setState(State.Free))
	else:
		state = deathState
		get_tree().create_timer(1.0).timeout.connect(func(): killPlayer())

func stopForce():
	# Very fast turnaround on ground
	return STOP_FORCE * 20.0 if is_on_floor() else STOP_FORCE * 0.7

func applyPhysics(xInput, triggerJump, delta):
	# Horizontal movement code. First, get the player's input.
	var appliedWalk = walkForce()
	var walk = appliedWalk * xInput
	# Slow down the player if they're not trying to move.
	var noXInput = abs(walk) < appliedWalk * 0.2
	var oppositeInput = xInput*velocity.x < 0
	if noXInput and is_on_floor():
		# Enchanced stop when not giving input on the ground (Erik shenanigans)
		velocity.x = move_toward(velocity.x, 0, stopForce() * 2 * delta)
	elif noXInput or (oppositeInput and is_on_floor()):
		velocity.x = move_toward(velocity.x, 0, stopForce() * delta)
	else:
		velocity.x += walk * delta
	# Clamp to the maximum horizontal movement speed.
	velocity.x = clamp(velocity.x, -walkSpeed(), walkSpeed())

	# Vertical movement code. Apply gravity.
	if inAntigrav:
		velocity.y -= gravity * 0.1 * delta
	elif state == State.Inflated:
		velocity.y = -100
	else:
		velocity.y += gravity * delta
		maybeLimitFall()
	
	var canTakeFallDamage = velocity.y > FALL_DAMAGE_LIMIT
	# Move based on the velocity and snap to the ground.
	move_and_slide()
	if get_slide_collision_count() > 0:
		# fix some collision are ok
		if canTakeFallDamage and is_on_floor():
			play_sfx("bonk")
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
	
func bulletHit(bulletPosition):
	if position.x > bulletPosition.x:
		direction = FacingDirection.Left
	else:
		direction = FacingDirection.Right
	velocity.y = 0
	takeDamage(State.HitStun, State.ShockDeath)

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
			if !useItem():
				play_sfx("itemFail")
		if state == State.Inflated and Input.is_action_just_pressed(&"B"):
			setState(State.Free)
	
	if killShock:
		killShock = false
		play_sfx("deathShock")
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
		velocity.x = facingDirected(-40)
		velocity.y += gravity * delta
		move_and_slide()
	if stateWithPhysics():
		applyPhysics(xInput, triggerJump, delta)
		if velocity.x > 0:
			direction = FacingDirection.Right
		elif velocity.x < 0:
			direction = FacingDirection.Left
	elif state == State.Ladder:
		position.x = ladderPos.x
		position.y += yInput * CLIMB_SPEED
		if position.y < ladderTop() or position.y > ladderBottom():
			state = State.Free

	decideAnimation(yInput, velocity)
