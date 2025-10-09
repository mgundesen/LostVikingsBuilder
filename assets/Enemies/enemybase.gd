extends Area2D

class_name Enemy

var itemScene = load("res://assets/Items/item.tscn")
var deathScene = load("res://assets/Enemies/death_animation.tscn")

enum State{walk, idle, attack, hurt}
var state = State.walk

@export var flip = false
var flipCooldown = false
var health = 1
var hitTypes = []
@export var itemType = ItemUtil.Item.none

func setState(newState):
	if state != State.hurt:
		state = newState
		
func spawnItem():
	var item = itemScene.instantiate()
	owner.add_child(item)
	item.position = position
	item.setItem(itemType)

func spawnDeathAnimation():
	var animation = deathScene.instantiate()
	owner.add_child(animation)
	animation.position = position

func _process(_delta):
	if state == State.hurt:
		position.x += 1.5 if flip else -1.5
	
	var type = CollisionUtil.isColliding(self, hitTypes)
	if type:
		if type == Hitbox.Type.explode or type == Hitbox.Type.smartbomb:
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
			state = State.hurt
			get_tree().create_timer(0.5).timeout.connect(func(): state = State.walk)

func doFlip():
	if !flipCooldown:
		flip = !flip
		flipCooldown = true
		get_tree().create_timer(0.1).timeout.connect(func(): flipCooldown = false)

func _on_body_entered(body: Node2D) -> void:
	if body is not PlayerBase and body is not OlafShield:
		doFlip()

func _on_edge_detect_hit_edge() -> void:
	doFlip()
