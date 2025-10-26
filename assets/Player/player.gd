extends CharacterBody2D
class_name PlayerBase

const STOP_FORCE = 1600
const WALK_FORCE = 1000
const WALK_MAX_SPEED = 340
const JUMP_SPEED = 550
const ANTIGRAV_BOUNCE = 100
const SPRING_FORCE = -850
const FALL_DAMAGE_LIMIT = 900
const SOUND_FALL_LIMIT = 200
const CLIMB_SPEED = 3

const bombScene = preload("res://assets/Items/bomb.tscn")
const hitboxScene = preload("res://assets/Hitbox/hitbox.tscn")

@onready var defaultGravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# Ladder interface
var ladderAllowed = false
var ladderPos = Vector2()
var ladderHeight = 0

# Teleport interface
var teleportAllowed = false
var teleportTarget = Vector2()

# Elevator interface
var onElevator

# Tredmill interface
var onTredmill = false
var tredmillSpeed = -1

# We are not a rigid body, maybe use this to implement the tredmill instead
var externalForce = Vector2.ZERO

# Control active interface
var controlActive = false

var inAntigrav = false
var imuneAntigrav = false

var playerHealth = 3
var itemSlot =  0
var items = [0,0,0,0]

enum State {Free, AttackMove, AttackMove2, Ladder, Inflating, Inflated, Teleport, HitStun, FallStun, 
			FallDeath, ShockDeath, SpikesDeath, SquashDeath, DrownDeath, DeathSkeleton, Dead}
var state = State.Free
enum FacingDirection {Left, Right}
var direction = FacingDirection.Right

var inflateTimer

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
	"squash": preload("res://assets/PlayerSounds/squash.mp3"),
	"deathSpikes": preload("res://assets/PlayerSounds/death_spikes.mp3"),
	"bow": preload("res://assets/PlayerSounds/bow.mp3"),
	"sword1": preload("res://assets/PlayerSounds/sword1.mp3"),
	"sword2": preload("res://assets/PlayerSounds/sword2.mp3"),
	"teleport": preload("res://assets/PlayerSounds/teleport.mp3"),
	"antigrav": preload("res://assets/PlayerSounds/antigrav.mp3")
}

func play_sfx(soundName: String):
	if playerHealth > 0: # Avoid overwriting death sounds with fall sound
		sfx.stream = sounds[soundName]
		SceneControl.playSound(sfx)

func _ready():
	set_platform_on_leave(PLATFORM_ON_LEAVE_DO_NOTHING)
	setupTimers()
	$AnimatedSprite2D.play("Idle")

func setupTimers():
	inflateTimer = Timer.new()
	add_child(inflateTimer)
	inflateTimer.wait_time = 6.0
	inflateTimer.one_shot = true
	inflateTimer.timeout.connect(func(): setState(State.Free))

func facingDirected(offset):
	return -offset if direction == FacingDirection.Left else offset

func spaceForItem():
	for index in range(4):
		if items[index] == 0:
			return true
	return false

func selectAnyItem():
	for index in range(4):
		if items[index] != 0:
			itemSlot = index
			return

func addItem(id, fromMenu = false):
	if !fromMenu:
		play_sfx("itemPickup")
	assert(spaceForItem())
	for index in range(4):
		if items[index] == 0:
			items[index] = id
			if items[itemSlot] == 0 or fromMenu:
				itemSlot = index
			return

func canUseFireArrow():
	return false

func spawnHitboxSmartbomb():
	var hitbox = hitboxScene.instantiate()
	hitbox.type = Hitbox.Type.smartbomb
	hitbox.find_child("CollisionShape2D").shape.set_size(Vector2(1000, 1000)) 
	add_child(hitbox)
	hitbox.call("despawn", 0.1)

func keyholeForItem(type):
	match items[itemSlot]:
		ItemUtil.Item.keyBlue:
			return ItemUtil.Keyhole.blue
		ItemUtil.Item.keyYellow:
			return ItemUtil.Keyhole.yellow
		ItemUtil.Item.keyRed:
			return ItemUtil.Keyhole.red

func useKey(type):
	for area in $Area2D.get_overlapping_areas():
		if area is KeyHole and area.type == keyholeForItem(type):
			area.call("open")
			return true
	return false

func useItemWithCheck():
	var sound = "itemUse"
	match items[itemSlot]:
		ItemUtil.Item.none:
			return false
		ItemUtil.Item.tomato, ItemUtil.Item.raddish, ItemUtil.Item.beef:
			if playerHealth < 3:
				playerHealth += 2 if items[itemSlot] == ItemUtil.Item.beef else 1
				sound = "itemUseFood"
			else:
				return false
		ItemUtil.Item.bomb:
			var bomb = bombScene.instantiate()
			owner.add_child(bomb)
			bomb.position = position
		ItemUtil.Item.keyBlue, ItemUtil.Item.keyYellow, ItemUtil.Item.keyRed:
			if !useKey(items[itemSlot]):
				return false
		ItemUtil.Item.smartbomb:
			spawnHitboxSmartbomb()
		ItemUtil.Item.gravboots:
			imuneAntigrav = true
		ItemUtil.Item.fireArrow:
			if !canUseFireArrow():
				return false
	
	items[itemSlot] = ItemUtil.Item.none
	itemSlot = (itemSlot + 1) %4
	play_sfx(sound)
	return true
	
func useItem():
	if !useItemWithCheck():
		play_sfx("itemFail")

func _implSpawnHitbox(offset, type):
	var hitboxPos = position
	hitboxPos.x += facingDirected(offset)
	CollisionUtil.spawnHitbox(owner, hitboxPos, type)
	
func spawnHitbox(offset, type = Hitbox.Type.basic):
	call_deferred("_implSpawnHitbox", offset, type)	

func stateWithPhysics():
	match state:
		State.Free, State.AttackMove, State.AttackMove2, State.FallStun, State.Inflated:
			return true
		_:
			return false

func stateWithInput():
	match state:
		State.Free, State.Ladder, State.Inflated:
			return true
		_:
			return false

func stateStunState():
	match state:
		State.HitStun:
			return true
		_:
			return false

func deathState(testState):
	match testState:
		State.FallDeath, State.ShockDeath, State.SpikesDeath, State.SquashDeath, State.DrownDeath, State.DeathSkeleton:
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

func enterAntigrav():
	inAntigrav = true
	if !imuneAntigrav:
		play_sfx("antigrav")

func decideAnimation(yInput, vel):
	$AnimatedSprite2D.flip_h = direction == FacingDirection.Left
	if state == State.FallDeath:
		$AnimatedSprite2D.play("Death_Fall")
	elif state == State.FallStun:
		$AnimatedSprite2D.play("Fall_Stun")
	elif state == State.ShockDeath:
		$AnimatedSprite2D.play("Death_Shock")
	elif state == State.SpikesDeath:
		$AnimatedSprite2D.play("Death_Spikes")
	elif state == State.SquashDeath:
		$AnimatedSprite2D.play("Squash")
	elif state == State.DrownDeath:
		$AnimatedSprite2D.play("Drown")
	elif state == State.DeathSkeleton:
		$AnimatedSprite2D.play("Death_Skeleton")
	elif state == State.HitStun:
		$AnimatedSprite2D.play("Hit")
	elif state == State.Inflating:
		$AnimatedSprite2D.play("Inflate")
	elif state == State.Inflated:
		$AnimatedSprite2D.play("Inflated")
	elif state == State.Teleport:
		$AnimatedSprite2D.play("Teleport")
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
	
func gravity():
	return defaultGravity

func killPlayer():
	state = State.Dead
	for i in range(4):
		items[i] = ItemUtil.Item.none
	visible = false
	#Remove collision
	set_collision_layer(0)
	set_collision_mask(0)
	
func stunTime():
	if state == State.FallStun:
		return 2.0
	else:
		return 0.7

func setState(targetState, forceFree: bool = false):
	# forcefree is so stunlogic can exit state again
	var stunlocked = (stateStunState() and !deathState(targetState) and forceFree == false)
	if deathState(state) or stunlocked:
		return
	state = targetState
	if targetState == State.Inflating:
		velocity = Vector2.ZERO
		get_tree().create_timer(0.3).timeout.connect(func(): setState(State.Inflated))
	if targetState == State.Inflated:
		inflateTimer.start()

func _takeDamage(stunState, deathState, amount = 1):
	if playerHealth < 1:
		return
	playerHealth -= amount
	if playerHealth > 0:
		play_sfx("hurt")
		setState(stunState)
		get_tree().create_timer(stunTime()).timeout.connect(func(): setState(State.Free, true))
	else:
		setState(deathState)
		get_tree().create_timer(1.0).timeout.connect(func(): killPlayer())

func stopForce():
	# Very fast turnaround on ground
	return STOP_FORCE * 20.0 if is_on_floor() else STOP_FORCE * 0.7
	
func size():
	return $CollisionShape2D.shape.size * scale

func ladderTop():
	return ladderPos.y - ladderHeight / 2.0 - size().y / 2.0

func ladderBottom():
	return ladderPos.y + ladderHeight / 2.0 - size().y / 2.0

func validLadderInput(yInput):
	if !ladderAllowed or abs(yInput) < 0.1:
		return false
	if yInput < 0: #Going up
		if position.y < ladderTop():
			return false
	if yInput > 0: #Going down
		if position.y > ladderBottom():
			return false
	if abs(yInput) < 0.1:
		return false
	return true

func getHit(sourcePosition, damageType, deathType):
	if position.x > sourcePosition.x:
		direction = FacingDirection.Left
	else:
		direction = FacingDirection.Right
	velocity.y = 0
	_takeDamage(damageType, deathType)

func bulletHit(bulletPosition, bulletType):
	var deathType = State.ShockDeath if bulletType == Bullet.Type.laser else State.DeathSkeleton
	getHit(bulletPosition, State.HitStun, deathType)

func kill(type):
	match type:
		KillArea.Type.Shock:
			play_sfx("deathShock")
			_takeDamage(State.ShockDeath, State.ShockDeath, 4)
		KillArea.Type.Spikes:
			play_sfx("deathSpikes")
			_takeDamage(State.SpikesDeath, State.SpikesDeath, 4)
		KillArea.Type.Squash:
			if is_on_floor():
				play_sfx("squash")
				_takeDamage(State.SquashDeath, State.SquashDeath, 4)
		KillArea.Type.Drown:
			_takeDamage(State.DrownDeath, State.DrownDeath, 4)

func handleLadderInput(xInput, yInput, triggerJump):
	if abs(yInput) < 0.1 and (abs(xInput) > 0 or triggerJump):
		setState(State.Free)
	position.x = ladderPos.x
	var touchingTiles = false
	for body in $Area2D.get_overlapping_bodies():
		if body is Tiles:
			touchingTiles = true
	position.y += yInput * CLIMB_SPEED
	if position.y < ladderTop() or (yInput > 0 and touchingTiles):
		setState(State.Free)

# Similar to move_toward but allows external forces to break limits
# This has a known bug that if you go with the external force speed limit is now broken
func moveWithLimitBreak(start, bound, diff):
	if abs(start) > abs(bound):
		return start + diff
	else:
		return clamp(start + diff, -bound, bound)

func applyPhysics(xInput, triggerJump, delta):
	# Horizontal movement code
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
		velocity.x = moveWithLimitBreak(velocity.x, walkSpeed(), walk * delta)

	# Vertical movement code
	if inAntigrav and !imuneAntigrav:
		velocity.y -= gravity() * 0.1 * delta
	elif state == State.Inflated:
		velocity.y = moveWithLimitBreak(velocity.y, 100, -1000 * delta)
	else:
		velocity.y += gravity() * delta
		maybeLimitFall()
	if triggerJump:
		velocity.y = -JUMP_SPEED
		if abs(velocity.x) > walkSpeed() - 70:
			const jumpMultiplier = 1.15
			velocity.y *= jumpMultiplier

	velocity += externalForce
	externalForce = Vector2.ZERO

	# Move based on the velocity and snap to the ground.
	var yBeforeMove = velocity.y
	move_and_slide()
	if get_slide_collision_count() > 0:
		var col = get_slide_collision(0).get_collider()
		if inAntigrav and col is TileMapLayer and abs(velocity.y) < 1:
			velocity.y = ANTIGRAV_BOUNCE
		# fix some collision are ok
		if yBeforeMove > FALL_DAMAGE_LIMIT and is_on_floor():
			_takeDamage(State.FallStun, State.FallDeath)
			play_sfx("bonk")
		elif yBeforeMove > SOUND_FALL_LIMIT and is_on_floor():
			play_sfx("landing")

func checkSpikeCollision():
	for body in $Area2D.get_overlapping_bodies():
		if body is Spikes:
			kill(KillArea.Type.Spikes)

func elevatorBonkHandling():
	if onElevator:
		for body in $Area2D.get_overlapping_bodies():
			if body is Tiles and !onElevator.isAtTarget():
				var offset = 14 if position.x > onElevator.position.x else -14
				position = onElevator.position
				position.y -= size().y / 2.0 + 1
				position.x += offset

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
		if state == State.Inflated and Input.is_action_just_pressed(&"B"):
			setState(State.Free)
			inflateTimer.stop()
		if teleportAllowed == true and Input.is_action_just_pressed(&"A") and is_on_floor() and state == State.Free:
			setState(State.Teleport)
			play_sfx("teleport")
			get_tree().create_timer(0.7).timeout.connect(func(): position = teleportTarget)
			get_tree().create_timer(1.6).timeout.connect(func(): setState(State.Free))
	
	checkSpikeCollision()
	# This still does not work well but probably better than being unfair to the player
	elevatorBonkHandling()
	if state == State.Free and validLadderInput(yInput):
		setState(State.Ladder)
		velocity = Vector2.ZERO
	if state == State.HitStun:
		velocity.x = facingDirected(-40)
		velocity.y += gravity() * delta
		move_and_slide()
	if state == State.Ladder:
		handleLadderInput(xInput, yInput, triggerJump)
	if stateWithPhysics():
		applyPhysics(xInput, triggerJump, delta)
	if onTredmill:
		position.x += tredmillSpeed

	#Not part of animation decision as inheritees are allowed early exit
	if !stateStunState():
		if velocity.x > 0:
			direction = FacingDirection.Right
		elif velocity.x < 0:
			direction = FacingDirection.Left
	decideAnimation(yInput, velocity)

func on_area_entered(area: Area2D) -> void:
	if area is Hitbox and area.type == Hitbox.Type.explode:
		_takeDamage(State.HitStun, State.ShockDeath)
