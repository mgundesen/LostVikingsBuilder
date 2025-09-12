extends Node2D

var currentPlayer = 0

func swap(playerFun):
	currentPlayer = playerFun.call(currentPlayer)
	while PlayerUtil.playerForIndex(currentPlayer).visible == false:
		currentPlayer = playerFun.call(currentPlayer)

func _process(_delta):
	var players = PlayerUtil.getPlayers()
	
	# check if all are dead
	var allDead = true
	for player in players:
		if player.visible == true:
			allDead = false
	if allDead:
		SceneControl.deathScene()
		return
	
	if Input.is_action_just_pressed(&"L"):
		swap(PlayerUtil.previousPlayer)
	if Input.is_action_just_pressed(&"R"):
		swap(PlayerUtil.nextPlayer)
	
	for i in range(3):
		var player = players[i]
		if !player:
			return

		#Swap in case player is dead
		if i == currentPlayer:
			if player.visible == false:
				swap(PlayerUtil.nextPlayer)

		player.set("controlActive", i == currentPlayer)
		if(i == currentPlayer):
			position = player.position
			position.y -= 40 # offset for the HUD
