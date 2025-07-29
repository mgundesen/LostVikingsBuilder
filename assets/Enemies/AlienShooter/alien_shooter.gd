extends Enemy

enum State{idle, walk, attack}
var state = State.idle
@export var flip = false 

func _ready():
	idleCycle()

func closeToPlayer():
	return PlayerUtil.closeToPlayer(position, 80, Vector2(-1,0) if flip else Vector2(1,0))
	
func shouldAttack():
	if closeToPlayer():
		state = State.attack
		$AnimatedSprite2D.set_frame_and_progress(0,0)
		get_tree().create_timer(0.3).timeout.connect(func(): EnemyUtil.fire(self, flip, -30))
		get_tree().create_timer(0.8).timeout.connect(func(): idleCycle())
		return true
	return false

func idleCycle():
	state = State.idle
	if !shouldAttack():
		get_tree().create_timer(0.4).timeout.connect(func(): walkCycle())

func walkCycle():
	state = State.walk
	if !shouldAttack():
		get_tree().create_timer(0.4).timeout.connect(func(): idleCycle())

func _process(_delta):
	if state == State.walk and !closeToPlayer():
		position.x += -2 if flip else 2

	$AnimatedSprite2D.flip_h = flip
	if state == State.idle:
		$AnimatedSprite2D.play("idle")
	elif state == State.walk:
		$AnimatedSprite2D.play("walk")
	elif state == State.attack:
		$AnimatedSprite2D.play("attack", 0.7)

func _on_body_entered(body: Node2D) -> void:
	if body is PlayerBase or body is Shield:
		pass
	else:
		flip = !flip

func _on_area_entered(area: Area2D) -> void:
	if area is Hitbox:
		# play death animation
		queue_free()
	
