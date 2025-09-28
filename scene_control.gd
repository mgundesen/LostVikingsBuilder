extends Node

enum PauseType {Regular, Item, Dialog, None}
var pauseState = PauseType.None

enum Dialog {Start, End}

func pauseType():
	return pauseState
	
func setPause(type):
	pauseState = type
	get_tree().paused = !pauseState == PauseType.None

func unpause():
	setPause(PauseType.None)

var currentScene = 0
var musicEnabled = true
var soundEnabled = true

const eColor = Color8(148, 0, 0)
const bColor = Color8(25, 121, 0)
const oColor = Color8(107, 65, 33)

var textBoxEnabled = true
const sceneList = [{"level" : "res://assets/Menu/main_menu.tscn"},
{"level" : "res://Levels/Chansey_Levels/Level1.tscn",
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
{"level" : "res://Levels/Chansey_Levels/Level3.tscn",
"text" : [[bColor, "abc."]],
"endText" : [[bColor, "abc."]]}
]

func nextScene():
	currentScene += 1
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
		if type == Dialog.Start:
			if "text" in sceneList[currentScene]:
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
