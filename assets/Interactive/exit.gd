extends Sprite2D

signal won

func _process(_delta):
	for player in PlayerUtil.getPlayers():
		if player.position.distance_to(position) > 150:
			return
	won.emit()
