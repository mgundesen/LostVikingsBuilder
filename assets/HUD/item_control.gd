extends Node2D
	
var basePos = [Vector2(0,0), Vector2(0,0), Vector2(0,0)]
const offset = [Vector2(0,0),Vector2(50,0),Vector2(0,50),Vector2(50,50)]

enum State {selecting, holding}
var state = State.selecting

var currentItem = ItemUtil.Item.none
var playerInSwap

func _ready():
	basePos[0] = $Player1/Image.position
	basePos[1] = $Player2/Image.position
	basePos[2] = $Player3/Image.position
	
	$Player1/ItemSprite2.call("setIcon",2)
		
func selectorForIndex(index):
	var path = "Player{index}/Image".format({"index": index+1})
	return get_node(path)

func nodeForItem(index, itemIndex):
	var path = "Player{index}/ItemSprite{itemIndex}".format({"index": index+1, "itemIndex": itemIndex+1})
	return get_node(path)
	
func drawItems():
	var playerIndex = 0
	for player in PlayerUtil.getPlayers():
		var itemIndex = 0
		var items = player.get("items")
		for item in items:
			var node = nodeForItem(playerIndex, itemIndex)
			node.call("setIcon", item)
			itemIndex+=1
		playerIndex+=1

func itemSlotChangeCheck(ap):
	var slot = ap.get("itemSlot")
	if Input.is_action_just_pressed(&"Right") and slot%2==0:
		ap.set("itemSlot", ap.get("itemSlot")+1)
	elif Input.is_action_just_pressed(&"Down") and slot<2:
		ap.set("itemSlot", ap.get("itemSlot")+2)
	elif Input.is_action_just_pressed(&"Left") and slot%2==1:
		ap.set("itemSlot", ap.get("itemSlot")-1)
	elif Input.is_action_just_pressed(&"Up") and slot>1:
		ap.set("itemSlot", ap.get("itemSlot")-2)
	else:
		return
	SceneControl.menuSoundNode().play_sfx("swap")

func currentPlayerIndex(currentPlayer):
	var playerIndex = 0
	for player in PlayerUtil.getPlayers():
		if player == currentPlayer:
			break
		playerIndex += 1
	return playerIndex

enum SwapType {next, previous}
func getPlayer(type):
	var currentIndex = currentPlayerIndex(playerInSwap)
	var players = PlayerUtil.getPlayers()
	if type == SwapType.next:
		return players[PlayerUtil.nextPlayer(currentIndex)]
	elif type == SwapType.previous:
		return players[PlayerUtil.previousPlayer(currentIndex)]

func swapItem(swapType):
	var next = getPlayer(swapType)
	playerInSwap.items[playerInSwap.itemSlot] = ItemUtil.Item.none
	next.addItem(currentItem, false)
	playerInSwap = next

func _process(_delta):
	drawItems()
	
	var relatedPause = SceneControl.pauseType() == SceneControl.PauseType.Item
	if Input.is_action_just_pressed(&"Select"):
		if relatedPause:
			state = State.selecting
			SceneControl.unpause()
		else:
			SceneControl.setPause(SceneControl.PauseType.Item)
	
	if relatedPause:
		if state == State.selecting:
			var ap = PlayerUtil.activePlayer()
			itemSlotChangeCheck(ap)
			if Input.is_action_just_pressed(&"B"):
				var item = ap.items[ap.itemSlot]
				if item != ItemUtil.Item.none:
					SceneControl.menuSoundNode().play_sfx("select")
					currentItem = item
					playerInSwap = ap
					state = State.holding
		else:
			if Input.is_action_just_pressed(&"Right"):
				swapItem(SwapType.next)
			if Input.is_action_just_pressed(&"Left"):
				swapItem(SwapType.previous)
			if Input.is_action_just_pressed(&"B"):
				state = State.selecting
				currentItem = ItemUtil.Item.none
				SceneControl.menuSoundNode().play_sfx("select")
	
	# Selector drawing
	var playerIndex = 0
	for player in PlayerUtil.getPlayers():
		var selector = selectorForIndex(playerIndex)
		selector.position = basePos[playerIndex] + offset[player.get("itemSlot")]
		if relatedPause and player.get("controlActive") and state == State.selecting:
			selector.play("default")
		else:
			selector.set_frame_and_progress(0,0)
			selector.stop()
		playerIndex+=1
