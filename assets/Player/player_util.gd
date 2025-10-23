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
	
func indexForPlayer(node):
	var index = 0
	for player in getPlayers():
		if node == player:
			return index
		index += 1
	return -1

func nextPlayer(player):
	var index = indexForPlayer(player)
	index += 1
	index %= getPlayers().size()
	return playerForIndex(index)

func previousPlayer(player):
	var index = indexForPlayer(player)
	var count = getPlayers().size()
	if index == 0:
		index = count-1
	else:
		index -= 1
	return playerForIndex(index)

func closeToPosition(sourcePosition, position, distance, searchDir):
	if sourcePosition.distance_to(position) < distance:
			if searchDir.length() > 0:
				if abs((position-sourcePosition).angle_to(searchDir)) < PI/4:
					return true
			else:
				return true
	return false
	
func frontShield():
	var olaf = getPlayers()[2]
	return olaf.find_child("front")

func closeToShield(sourcePosition, distance, searchDir = Vector2(0,0)):
	var olaf = getPlayers()[2]
	if olaf.raisedSheild:
		return false
	var pos = olaf.position + olaf.facingDirected(Vector2(45,0))
	if closeToPosition(sourcePosition, pos, distance, searchDir):
		return true
	return false

func closeToPlayer(sourcePosition, distance, searchDir = Vector2(0,0)):
	for player in getPlayers():
		if player.playerHealth <= 0:
			continue
		if closeToPosition(sourcePosition, player.position, distance, searchDir):
				return player
	return null
