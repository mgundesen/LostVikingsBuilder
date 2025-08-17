extends Area2D

enum State{Open, Closed, Opening, Closing}
var state = State.Closed

func _process(_delta):
	var close = PlayerUtil.closeToPlayer(position, 120)
	if state == State.Closed and close:
		state = State.Opening
		get_tree().create_timer(0.07).timeout.connect(func(): state = State.Open)
	if state == State.Open and !close:
		state = State.Closing
		get_tree().create_timer(0.07).timeout.connect(func(): state = State.Closed)
	
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
