extends Node2D

enum Active {Left, Right}
var active = Active.Left

func bounce(otherArea, body, newState):
	for otherBody in otherArea.get_overlapping_bodies():
		if otherBody is PlayerBase and otherBody != body:
			otherBody.velocity.y = PlayerBase.SPRING_FORCE
	active = newState
	body.velocity.y = body.velocity.y / 2
	SceneControl.playSound($AudioStreamPlayer2D)
	# collision area is just left always high as it works fine without being correct

func _left_body_entered(body: Node2D) -> void:
	if active == Active.Right and body.velocity.y > 0:
		bounce($RightArea, body, Active.Left)

func _right_body_entered(body: Node2D) -> void:
	if active == Active.Left and body.velocity.y > 0:
		bounce($LeftArea, body, Active.Right)

func _process(_delta):
	if active == Active.Right:
		$AnimatedSprite2D.play("right")
	if active == Active.Left:
		$AnimatedSprite2D.play("left")
