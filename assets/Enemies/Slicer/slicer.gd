extends Enemy

var onCooldown = false
#Note, can in theory break through a wall if flipCooldown and agroCooldown
#hits a very specific timing
var aggroCooldown = false 

func _ready() -> void:
	health = 3

func turnToPlayer():
	if !aggroCooldown:
		aggroCooldown = true
		get_tree().create_timer(1.0).timeout.connect(func(): aggroCooldown = false)
		return PlayerUtil.closeToPlayer(position, 300, Vector2(1,0) if flip else Vector2(-1,0))
	return false
	
func _process(delta):
	if turnToPlayer():
		doFlip()
	if state == State.hurt:
		position.x += 1 if flip else -1
	if !onCooldown:
		position.x += -2 if flip else 2
	$Sprite2D.flip_h = flip
	super._process(delta)

func _on_body_entered(body: Node2D) -> void:
	if body is PlayerBase:
		body.getHit(position, PlayerBase.State.HitStun, PlayerBase.State.DeathSkeleton)
		onCooldown = true
		get_tree().create_timer(body.stunTime() + 0.1).timeout.connect(func(): onCooldown = false)
	super._on_body_entered(body)
