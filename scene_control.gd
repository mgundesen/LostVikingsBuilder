extends Node

const sceneList = [
{"level" : "res://assets/Menu/main_menu.tscn"},
{"level" : "res://Levels/Chansey_Levels/Level1.tscn",
 "name" : "ESCP",
"text" : [[bColor, "Waking up in a cell again... this is starting to feel like a tradition."],
		 [eColor, "Tradition? Feels more like a recurring side quest at this point."],
		 [bColor, "Well, the guards actually remembered to lock our cell this time."],
		 [oColor, "At least they also left some food for us! I'm starving"],
		 [bColor, "Quit yea blabbering! Do you see the gap in the wall? Erik do you think you can make it?"],
		 [eColor, "Sure or else I wouldn't be Erik the Swift. Time to get busy escaping."]],
"endText" : [[oColor, "Do you think Tomator well be mad about us escaping again?"],
			[eColor, "Since when have that started bothering you?"],
			[oColor, "Dunno, maybe him yet again being alive to do his tricks."],
			[bColor, "I'm betting this is someone else pulling the strings!"]]},
{"level" : "res://Levels/Chansey_Levels/Level2.tscn",
 "name" : "LOOP"},
{"level" : "res://Levels/Chansey_Levels/Level3.tscn",
 "name" : "ELVT"},
{"level" : "res://Levels/Chansey_Levels/Level4.tscn",
 "name" : "MIXD",
"text" : [],
"endText" : []},
{"level" : "res://Levels/Chansey_Levels/Level5.tscn",
 "name" : "CHAI"},
{"level" : "res://Levels/Chansey_Levels/Level6.tscn",
 "name" : "CLSE"},
{"level" : "res://Levels/Chansey_Levels/Level7.tscn",
 "name" : "SENS"},
{"level" : "res://Levels/Chansey_Levels/Level8.tscn",
 "name" : "BONK"},
{"level" : "res://Levels/Chansey_Levels/Level9.tscn",
 "name" : "FANS"},
{"level" : "res://Levels/Chansey_Levels/Level10.tscn",
 "name" : "TODO"}
]

var currentScene = 0
var musicEnabled = false
var soundEnabled = true
var startTextAllowed = false;

enum PauseType {Regular, Item, Dialog, None}
var pauseState = PauseType.None

enum Dialog {Start, End}

func menuSoundNode():
	return get_node("/root/Node2D/HUD/MenuSound")

func pauseType():
	return pauseState
	
func setPause(type):
	if type == PauseType.Regular or type == PauseType.Item:
		menuSoundNode().enterPause()
	if pauseState == PauseType.None:
		pauseState = type
		get_tree().paused = !pauseState == PauseType.None

func unpause():
	pauseState = PauseType.None
	get_tree().paused = !pauseState == PauseType.None

const eColor = Color8(148, 0, 0)
const bColor = Color8(25, 121, 0)
const oColor = Color8(107, 65, 33)

var textBoxEnabled = true

func nextScene():
	currentScene += 1
	startTextAllowed = true
	if sceneList.size() == currentScene:
		currentScene = 0
	get_tree().change_scene_to_file(sceneList[currentScene]["level"])

func continueScene():
	get_tree().change_scene_to_file(sceneList[currentScene]["level"])
	
func mainScene():
	currentScene = 0
	get_tree().change_scene_to_file(sceneList[currentScene]["level"])

func deathScene():
	get_tree().change_scene_to_file("res://assets/Menu/death_scene.tscn")
	
func textForScene(type):
	if textBoxEnabled:
		if type == Dialog.Start and startTextAllowed:
			if "text" in sceneList[currentScene]:
				startTextAllowed = false
				return sceneList[currentScene]["text"]
		elif type == Dialog.End:
			if "endText" in sceneList[currentScene]:
				return sceneList[currentScene]["endText"]
	return []
		
func getMusicEnabled():
	return musicEnabled

func playSound(node):
	if soundEnabled:
		node.play()
