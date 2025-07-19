extends CanvasLayer

func _process(_delta):
	var players = PlayerUtil.getPlayers()
	var index = 1
	for player in players:
		var health = player.get("playerHealth")
		for i in range(3):
			var path = "H{player}_{health_index}".format({"player": index,"health_index": i+1})
			get_node(path).visible = (i+1 <= health)
		index += 1
