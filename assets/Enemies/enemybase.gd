extends Area2D

class_name Enemy

var itemScene = load("res://assets/Items/item.tscn")

enum State{walk, idle, attack, hurt}
var state = State.walk

@export var flip = false 
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

func _process(_delta):
	if state == State.hurt:
		position.x += 1.5 if flip else -1.5
	
	var type = CollisionUtil.isColliding(self, hitTypes)
	if type:
		if type == Hitbox.Type.explode:
			health -= 3
		else:
			health -= 1
		if health <= 0:
			# play death animation
			if itemType != ItemUtil.Item.none:
				spawnItem()
			queue_free()
		else:
			state = State.hurt
			get_tree().create_timer(0.5).timeout.connect(func(): state = State.walk)
