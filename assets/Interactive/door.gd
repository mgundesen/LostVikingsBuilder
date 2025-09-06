extends CharacterBody2D

class_name Door

enum State{Open, Closed, Opening, Closing}
var state = State.Closed

enum Mode{Auto, Signals}
@export var operationMode = Mode.Signals 

@onready var sfx = $AudioStreamPlayer2D

# Preload sound effects
const sounds = {
	"open": preload("res://assets/Sounds/door_open.mp3"),
	"close": preload("res://assets/Sounds/door_close.mp3")
}

func play_sfx(name: String):
	sfx.stream = sounds[name]
	sfx.play()


func setCollision(on):
	for layer in range(4):
		set_collision_layer_value(layer+1, on)
		set_collision_mask_value(layer+1, on)

func open():
	play_sfx("open")
	state = State.Open
	setCollision(false)

func close():
	play_sfx("close")
	state = State.Closed
	setCollision(true)

func toggle():
	if state == State.Open:
		close()
	else:
		open()

func _process(_delta):
	if operationMode == Mode.Auto:
		var close = PlayerUtil.closeToPlayer(position, 120)
		if state == State.Closed and close:
			state = State.Opening
			get_tree().create_timer(0.07).timeout.connect(func(): open())
		if state == State.Open and !close:
			state = State.Closing
			get_tree().create_timer(0.07).timeout.connect(func(): close())
	
	if state == State.Closed:
		$AnimatedSprite2D.play("default")
		$AnimatedSprite2D.set_frame_and_progress(0, 0)
	if state == State.Open:
		$AnimatedSprite2D.play("default")
		$AnimatedSprite2D.set_frame_and_progress(3, 0)
	if state == State.Opening:
		$AnimatedSprite2D.play("default", 3.0)
	if state == State.Closing:
		$AnimatedSprite2D.play("default", -3.0, true)
