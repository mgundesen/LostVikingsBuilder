extends Node2D

enum Menu {Main, Settings, LevelSelect}
var state = Menu.Main

func updateSettingText():
	$Settings.toggle(0, SceneControl.musicEnabled)
	$Settings.toggle(1, SceneControl.soundEnabled)

func updateLevelText():
	$LevelSelect.textLabels.clear()
	for i in range(SceneControl.sceneList.size()):
		if i > 0:
			$LevelSelect.textLabels.append("Level {index}".format({"index": i}))
	$LevelSelect.textLabels.append("Exit")
	$LevelSelect.updateLabels(34)

func _ready() -> void:
	updateSettingText()
	updateLevelText()

func _process(_delta: float) -> void:
	$GeneralChoices.setActive(state == Menu.Main)
	$Settings.setActive(state == Menu.Settings)
	$LevelSelect.setActive(state == Menu.LevelSelect)
	
	var hasInput = Input.is_action_just_pressed(&"B") or Input.is_action_just_pressed(&"Start")
	if !hasInput:
		return
	
	if state == Menu.Main:
		if $GeneralChoices.currentIndex == 0:
			SceneControl.nextScene()
		elif $GeneralChoices.currentIndex == 1:
			state = Menu.Settings
		elif $GeneralChoices.currentIndex == 2:
			state = Menu.LevelSelect
	elif state == Menu.Settings:
		if $Settings.currentIndex == 0:
			SceneControl.musicEnabled = !SceneControl.musicEnabled 
			updateSettingText()
		elif $Settings.currentIndex == 1:
			SceneControl.soundEnabled = !SceneControl.soundEnabled 
			updateSettingText()
		elif $Settings.currentIndex == 2:
			$Settings.currentIndex = 0
			state = Menu.Main
	elif state == Menu.LevelSelect:
		if SceneControl.sceneList.size() - 1 == $LevelSelect.currentIndex:
			$LevelSelect.currentIndex = 0
			state = Menu.Main
		else:
			SceneControl.currentScene = $LevelSelect.currentIndex
			SceneControl.nextScene()
