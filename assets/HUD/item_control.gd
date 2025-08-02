extends Node2D

enum PauseType {Regular, Item, None}
var type = PauseType.None
	
var basePos = [Vector2(0,0), Vector2(0,0), Vector2(0,0)]
const offset = [Vector2(0,0),Vector2(50,0),Vector2(0,50),Vector2(50,50)] 

func _ready():
	basePos[0] = $Player1/Image.position
	basePos[1] = $Player2/Image.position
	basePos[2] = $Player3/Image.position
	
	$Player1/ItemSprite2.call("setIcon",2)

func pause(pauseType):
	get_tree().paused = !get_tree().paused
	if type == PauseType.None:
		type = pauseType
	else:
		type = PauseType.None
		
func nodeForIndex(index):
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
		
func _process(_delta):
	drawItems()
	
	if Input.is_action_just_pressed(&"Select"):
		pause(PauseType.Item)
	
	if type == PauseType.Item:
		var playerIndex = 0
		for player in PlayerUtil.getPlayers():
			if player.get("controlActive"):
				nodeForIndex(playerIndex).play("default")
				var slot = player.get("itemSlot")
				if Input.is_action_just_pressed(&"Right") and slot%2==0:
					player.set("itemSlot", player.get("itemSlot")+1)
				if Input.is_action_just_pressed(&"Down") and slot<2:
					player.set("itemSlot", player.get("itemSlot")+2)
				if Input.is_action_just_pressed(&"Left") and slot%2==1:
					player.set("itemSlot", player.get("itemSlot")-1)
				if Input.is_action_just_pressed(&"Up") and slot>1:
					player.set("itemSlot", player.get("itemSlot")-2)
				
			nodeForIndex(playerIndex).position = basePos[playerIndex] + offset[player.get("itemSlot")]
			playerIndex+=1
	else:
		for i in range(3):
			var node = nodeForIndex(i)
			node.set_frame_and_progress(0,0)
			node.stop()
		type = PauseType.None
	
