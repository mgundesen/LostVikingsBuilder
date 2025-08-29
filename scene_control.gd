extends Node

var currentScene = 0

var sceneList = ["res://assets/Menu/main_menu.tscn",
				 "res://Level2/level2.tscn"]

func nextScene():
	currentScene += 1
	get_tree().change_scene_to_file(sceneList[currentScene])

func continueScene():
	get_tree().change_scene_to_file(sceneList[currentScene])
	
func mainScene():
	currentScene = 0
	get_tree().change_scene_to_file(sceneList[currentScene])

func deathScene():
	get_tree().change_scene_to_file("res://assets/Menu/death_scene.tscn")
