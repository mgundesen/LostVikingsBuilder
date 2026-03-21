extends Enemy

var onCooldown = false

func _ready() -> void:
	health = 3
	isAggro = true
	super._ready()

func _physics_process(delta):
	if state == State.hurt:
		position.x += 1 if flip else -1
	if !onCooldown:
		position.x += -2 if flip else 2
	$Sprite2D.flip_h = flip
	super._physics_process(delta)

func _on_body_entered(body: Node2D) -> void:
	if body is PlayerBase:
		body.getHit(position, PlayerBase.State.HitStun, PlayerBase.State.DeathSkeleton)
		onCooldown = true
		get_tree().create_timer(body.stunTime() + 0.1).timeout.connect(func(): onCooldown = false)
	super._on_body_entered(body)
