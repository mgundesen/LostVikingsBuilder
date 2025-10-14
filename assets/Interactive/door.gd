extends CharacterBody2D

class_name Door

enum State{Open, Closed, Opening, Closing}
var state = State.Closed

enum Mode{Auto, Signals, Timed}
@export var operationMode = Mode.Signals
@export var timer = 2.0
@export var openCount = 1
enum Style{Ship, Candyland}
@export var style = Style.Ship

@onready var sfx = $AudioStreamPlayer2D

# Preload sound effects
const sounds = {
	"open": preload("res://assets/Sounds/door_open.mp3"),
	"close": preload("res://assets/Sounds/door_close.mp3"),
	"candylandDoor": preload("res://assets/Sounds/cdoor.mp3")
}

func play_sfx(soundName: String):
	sfx.stream = sounds[soundName]
	SceneControl.playSound(sfx)

func setCollision(on):
	for layer in range(4):
		set_collision_layer_value(layer+1, on)
		set_collision_mask_value(layer+1, on)

func open():
	openCount -= 1
	if openCount == 0:
		play_sfx("open" if style == Style.Ship else "candylandDoor")
		state = State.Opening
		var openTime = 0.07 if style == Style.Ship else 0.8
		get_tree().create_timer(openTime).timeout.connect(func(): state = State.Open)
		setCollision(false)
		if operationMode == Mode.Timed:
			get_tree().create_timer(timer).timeout.connect(close)

func close():
	openCount += 1
	play_sfx("close" if style == Style.Ship else "candylandDoor")
	state = State.Closing
	var openTime = 0.07 if style == Style.Ship else 0.8
	get_tree().create_timer(openTime).timeout.connect(func(): state = State.Closed)
	setCollision(true)

func toggle():
	if state == State.Open:
		close()
	else:
		open()

func _process(_delta):
	if operationMode == Mode.Auto:
		var isClose = PlayerUtil.closeToPlayer(position, 120)
		if state == State.Closed and isClose:
			open()
		if state == State.Open and !isClose:
			close()
	
	var sprite = "default" if style == Style.Ship else "candydefault"
	var count = $AnimatedSprite2D.sprite_frames.get_frame_count(sprite) - 1
	
	if state == State.Closed:
		$AnimatedSprite2D.play(sprite)
		$AnimatedSprite2D.set_frame_and_progress(0, 0)
	if state == State.Open:
		$AnimatedSprite2D.play(sprite)
		$AnimatedSprite2D.set_frame_and_progress(count, 0)
	if state == State.Opening:
		$AnimatedSprite2D.play(sprite, 3.0)
	if state == State.Closing:
		$AnimatedSprite2D.play(sprite, -3.0, true)
