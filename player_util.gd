extends Node2D

func getPlayers():
	var players = [get_node("/root/Node2D/Erik"), 
				   get_node("/root/Node2D/Balerog"), 
				   get_node("/root/Node2D/Olaf")]
	return players

func closeToPlayer(sourcePosition, distance, searchDir = Vector2(0,0)):
	for player in getPlayers():
		if sourcePosition.distance_to(player.position) < distance:
			if searchDir.length() > 0:
				if abs((player.position-sourcePosition).angle_to(searchDir)) < PI/2:
					return true
			else:
				return true
	return false
