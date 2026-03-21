extends CharacterBody2D

class_name Enemy

var itemScene = load("res://assets/Items/item.tscn")
var deathScene = load("res://assets/Enemies/death_animation.tscn")
var hitVisual = load("res://assets/Enemies/hit_visual.tscn")

enum State{walk, idle, attack, hurt}
var state = State.walk

@export var flip = false
# cooldown to avoid multiple flips if colliding with multiple things at the same time
var flipCooldown = false
var health = 1
var hitTypes = []
@export var itemType = ItemUtil.Item.none
@export var bounds = 100000
var xLimit = []

#Note, can in theory break through a wall if flipCooldown and agroCooldown
#hits a very specific timing
var isAggro = false
var aggroCooldown = false
var aggroRange = 300

func _ready() -> void:
	xLimit.resize(2)
	xLimit[0] = position.x - bounds * 46
	xLimit[1] = position.x + bounds * 46

func setState(newState):
	if state != State.hurt:
		state = newState
		
func spawnItem():
	var item = itemScene.instantiate()
	owner.add_child(item)
	item.position = position
	item.setItem(itemType)

func spawnHitVisual():
	var visual = hitVisual.instantiate()
	owner.add_child(visual)
	visual.position = position

func spawnDeathAnimation():
	var animation = deathScene.instantiate()
	owner.add_child(animation)
	animation.position = position
	animation.position.y -= 10 # This offset should use enemy height to be correct

func turnToPlayer():
	if !aggroCooldown:
		aggroCooldown = true
		get_tree().create_timer(0.3).timeout.connect(func(): aggroCooldown = false)
		return PlayerUtil.closeToPlayer(position, aggroRange, Vector2(1,0) if flip else Vector2(-1,0))
	return false

func _process(_delta):
	move_and_slide()
	if state == State.hurt:
		position.x += 1.5 if flip else -1.5
	if xLimit[0] > position.x or xLimit[1] < position.x:
		doFlip()
	if isAggro and turnToPlayer():
		doFlip()
	
	var area = CollisionUtil.isColliding($Area2D, hitTypes)
	if area:
		if area.position.x > position.x and flip or area.position.x < position.x and !flip:
			doFlip()
		if area.type == Hitbox.Type.explode or area.type == Hitbox.Type.smartbomb or area.type == Hitbox.Type.fireArrow:
			health -= 3
		else:
			health -= 1
		if health <= 0:
			# play death animation
			if itemType != ItemUtil.Item.none:
				spawnItem()
			spawnDeathAnimation()
			queue_free()
		else:
			spawnHitVisual()
			state = State.hurt
			get_tree().create_timer(0.5).timeout.connect(func(): state = State.walk)

func doFlip():
	if !flipCooldown:
		flip = !flip
		flipCooldown = true
		get_tree().create_timer(0.01).timeout.connect(func(): flipCooldown = false)

func _on_body_entered(body: Node2D) -> void:
	if body is not PlayerBase and body is not OlafShield and body is not Enemy:
		doFlip()

func _on_edge_detect_hit_edge() -> void:
	doFlip()
