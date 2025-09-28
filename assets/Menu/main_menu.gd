extends Node2D

enum Menu {Main, Settings}
var state = Menu.Main

func updateSettingText():
	$Settings.toggle(0, SceneControl.musicEnabled)
	$Settings.toggle(1, SceneControl.soundEnabled)

func _ready() -> void:
	updateSettingText()

func _process(_delta: float) -> void:
	$GeneralChoices.setActive(state == Menu.Main)
	$Settings.setActive(state == Menu.Settings)
	
	var hasInput = Input.is_action_just_pressed(&"B") or Input.is_action_just_pressed(&"Start")
	if !hasInput:
		return
	
	if state == Menu.Main:
		if $GeneralChoices.currentIndex == 0:
			SceneControl.nextScene()
		elif $GeneralChoices.currentIndex == 1:
			$Settings.currentIndex = 0
			state = Menu.Settings
	elif state == Menu.Settings:
		if $Settings.currentIndex == 0:
			SceneControl.musicEnabled = !SceneControl.musicEnabled 
			updateSettingText()
		elif $Settings.currentIndex == 1:
			SceneControl.soundEnabled = !SceneControl.soundEnabled 
			updateSettingText()
		elif $Settings.currentIndex == 2:
			state = Menu.Main
