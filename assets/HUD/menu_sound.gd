extends AudioStreamPlayer

const sounds = {
	"enter": preload("res://assets/Sounds/openmenu.mp3"),
	"select": preload("res://assets/Sounds/itemselect.mp3"),
	"swap": preload("res://assets/Sounds/itemslotswap.mp3"),
	"itemFail": preload("res://assets/PlayerSounds/item_fail.mp3")
}

func play_sfx(soundName: String):
	stream = sounds[soundName]
	SceneControl.playSound(self)

func enterPause():
	play_sfx("enter")
	
