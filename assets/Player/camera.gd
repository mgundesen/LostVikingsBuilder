extends Node2D

var currentPlayer

func _ready() -> void:
	currentPlayer = PlayerUtil.getPlayers().front()
	
func swap(playerFun):
	currentPlayer = playerFun.call(currentPlayer)
	while currentPlayer.visible == false:
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
	
	for player in PlayerUtil.getPlayers():
		if !player:
			return

		#Swap in case player is dead
		if player == currentPlayer:
			if player.visible == false:
				swap(PlayerUtil.nextPlayer)

		player.set("controlActive", player == currentPlayer)
		if(player == currentPlayer):
			position = player.position
			position.y -= 40 # offset for the HUD
