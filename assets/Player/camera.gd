extends Node2D

var currentPlayer = 0

func _process(_delta):
	var players = PlayerUtil.getPlayers()
		
	if Input.is_action_just_pressed(&"SwapLeft"):
		currentPlayer = PlayerUtil.previousPlayer(currentPlayer)
	if Input.is_action_just_pressed(&"SwapRight"):
		currentPlayer = PlayerUtil.nextPlayer(currentPlayer)
	
	for i in range(3):
		var player = players[i]
		if !player:
			return

		if i == currentPlayer:
			if player.get("visible") == false:
				currentPlayer = PlayerUtil.nextPlayer(currentPlayer)

		player.set("controlActive", i == currentPlayer)
		if(i == currentPlayer):
			position = player.position
			position.y -= 40 # offset for the HUD
