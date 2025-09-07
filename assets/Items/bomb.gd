extends CharacterBody2D

@onready var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var hitboxScene = load("res://assets/Hitbox/hitbox.tscn")

enum State{pending, explode}
var state = State.pending

func spawnHitbox():
	var hitbox = hitboxScene.instantiate()
	hitbox.type = Hitbox.Type.explode
	hitbox.find_child("CollisionShape2D").shape.set_size(Vector2(100, 120)) 
	add_child(hitbox)
	hitbox.call("despawn", 0.5)

func explode():
	state = State.explode
	SceneControl.playSound($AudioStreamPlayer2D)
	spawnHitbox()
	get_tree().create_timer(0.5).timeout.connect(func(): queue_free())

func _ready():
	get_tree().create_timer(3.0).timeout.connect(func(): explode())

func _physics_process(delta: float):
	velocity.y += gravity * delta
	move_and_slide()
	
	if state == State.pending:
		$AnimatedSprite2D.play("default", 2.5)
	else:
		$AnimatedSprite2D.play("boom")
