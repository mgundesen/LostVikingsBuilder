extends Node

var currentScene = 0

var sceneList = ["res://play_scene.tscn",
				 "res://Level2/level2.tscn"]

func nextScene():
	currentScene += 1
	get_tree().change_scene_to_file(sceneList[currentScene])
