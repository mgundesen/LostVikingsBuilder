extends Node

var currentScene = 0

var eColor = Color8(148, 0, 0)
var bColor = Color8(25, 121, 0)
var oColor = Color8(107, 65, 33)

var sceneList = [{"level" : "res://assets/Menu/main_menu.tscn"},
				{"level" : "res://Level2/level2.tscn",
				"text" : [[bColor, "Waking up in a cell again... this is starting to feel like a tradition."],
						  [eColor, "Tradition? Feels more like a recurring side quest at this point."],
						  [bColor, "Tradition or not, the guards actually remembered to lock our cell this time."],
						  [oColor, "At least they also left some food for us, I'm starving"],
						  [bColor, "Tradition or not, the guards actually remembered to lock our cell this time."],
						  [eColor, "... Get busy living or get busy dying. Time to get busy escaping."]]}]

func nextScene():
	currentScene += 1
	get_tree().change_scene_to_file(sceneList[currentScene]["level"])

func continueScene():
	get_tree().change_scene_to_file(sceneList[currentScene]["level"])
	
func mainScene():
	currentScene = 0
	get_tree().change_scene_to_file(sceneList[currentScene]["level"])

func deathScene():
	get_tree().change_scene_to_file("res://assets/Menu/death_scene.tscn")
	
func textForScene():
	return sceneList[currentScene]["text"]
