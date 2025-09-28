extends Sprite2D

signal won
var transition = false

func _process(_delta):
	if transition:
		return
	for player in PlayerUtil.getPlayers():
		if player.position.distance_to(position) > 150:
			return
	transition = true
	won.emit()
	get_parent().get_parent().get_node("FadeScene").fadeout()
	get_tree().create_timer(0.5).timeout.connect(func(): SceneControl.nextScene())
