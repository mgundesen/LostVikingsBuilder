extends Area2D

@export var flip = false
@export var shootTime = 3.5
enum State {idle, shoot}
var state = State.idle

func _ready():
	$Timer.start()
	if flip:
		$AnimatedSprite2D.flip_h = true
	$Timer.wait_time = shootTime

func _on_timer_timeout() -> void:
	EnemyUtil.fire(self, flip)
	state = State.shoot
	get_tree().create_timer(0.1).timeout.connect(func(): state = State.idle)

func _process(_delta):
	if CollisionUtil.isColliding(self, [Hitbox.Type.explode]):
		queue_free()
	
	if state == State.idle:
		$AnimatedSprite2D.play("default")
	if state == State.shoot:
		$AnimatedSprite2D.play("shoot")
