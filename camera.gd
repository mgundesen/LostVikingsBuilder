extends Node2D

var currentPlayer = 0

func nextPlayer():
	currentPlayer += 1
	currentPlayer %= PlayerUtil.getPlayers().size()

func previousPlayer():
	var count = PlayerUtil.getPlayers().size()
	if currentPlayer == 0:
		currentPlayer = count-1
	else:
		currentPlayer -= 1

func _process(_delta):
	var players = PlayerUtil.getPlayers()
		
	if Input.is_action_just_pressed(&"SwapLeft"):
		previousPlayer()
	if Input.is_action_just_pressed(&"SwapRight"):
		nextPlayer()
	
	for i in range(3):
		var player = players[i]
		if !player:
			return

		if i == currentPlayer:
			if player.get("visible") == false:
				nextPlayer()

		player.set("controlActive", i == currentPlayer)
		if(i == currentPlayer):
			position = player.position
			position.y -= 40 # offset for the HUD
