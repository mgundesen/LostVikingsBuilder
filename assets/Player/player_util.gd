extends Node2D

func getPlayers():
	var players = [get_node("/root/Node2D/Erik"), 
				   get_node("/root/Node2D/Balerog"), 
				   get_node("/root/Node2D/Olaf")]
	return players

func getOverlappingActive(area):
	for body in area.get_overlapping_bodies():
		if body is PlayerBase:
			if body.get("controlActive") == true:
				return body
	return null

func activePlayer():
	for player in getPlayers():	
		if player.get("controlActive"):
			return player

func playerForIndex(index):
	return getPlayers()[index]

func nextPlayer(index):
	index += 1
	index %= getPlayers().size()
	return index

func previousPlayer(index):
	var count = getPlayers().size()
	if index == 0:
		index = count-1
	else:
		index -= 1
	return index

func closeToPlayer(sourcePosition, distance, searchDir = Vector2(0,0)):
	for player in getPlayers():
		if sourcePosition.distance_to(player.position) < distance:
			if searchDir.length() > 0:
				if abs((player.position-sourcePosition).angle_to(searchDir)) < PI/4:
					return player
			else:
				return player
	return null
