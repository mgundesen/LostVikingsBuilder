extends Node2D

var currentPlayer = 0
const playerCount = 2

func _process(delta):
	if Input.is_action_just_pressed(&"SwapLeft"):
		currentPlayer += 1
		currentPlayer %= playerCount
	
	var players = [get_node("../Erik"), get_node("../Olaf")]
	for i in range(2):
		var player = players[i]
		if player:
			player.set("controlActive", i == currentPlayer)
			if(i == currentPlayer):
				position = player.position
				position.y -= 40 # offset for the HUD
