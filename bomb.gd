extends CharacterBody2D

@onready var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

enum State{pending, explode}
var state = State.pending

func explode():
	state = State.explode
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
		
