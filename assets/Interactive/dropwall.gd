extends CharacterBody2D

@export var fallSpeed = 1.0
var disabled = false
var frontShield
enum Style{Ship, Candyland, Egypt}
@export var style = Style.Ship

func _ready() -> void:
	var path = "res://assets/Interactive/dropwall.png"
	if style == Style.Egypt:
		path = "res://assets/Interactive/edoor.png"
	$Sprite2D.texture = load(path)
	frontShield = PlayerUtil.frontShield()
	add_collision_exception_with(frontShield)

func _physics_process(_delta: float) -> void:
	if !disabled:
		position.y += fallSpeed
		velocity = Vector2()
		move_and_slide()

func _on_body_entered(body: Node2D) -> void:
	if body is OlafShield and body != frontShield:
		disabled = true
	if body is PlayerBase:
		body.kill(KillArea.Type.Squash)

func _on_body_exited(body: Node2D) -> void:
	if body is OlafShield and body != frontShield:
		disabled = false
