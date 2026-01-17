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
		 [eColor, "Sure or else I wouldn't be Erik the Swift."]],
"endText" : [[oColor, "Do you think Tomator will be mad about us escaping again?"],
			[eColor, "Since when have that started bothering you?"],
			[oColor, "... Since we learned his secret identity I guess? Let's move on."]]},
{"level" : "res://Levels/Chansey_Levels/Level2.tscn",
 "name" : "LOOP",
"text" : [[eColor, "Oh boy, some more walls to tear down."],
		 [bColor, "Uhh, didn't you say last time you got tired of it."],
		 [eColor, "How would I ever get tired of the endless headache it causes!"],
		 [bColor, "..."]],
"endText" : []},
{"level" : "res://Levels/Chansey_Levels/Level3.tscn",
 "name" : "ELVT",
"text" : [[bColor, "Olaf, can't you just do this level for me? Not too happy about what I see."],
		 [oColor, "You mean floating down into traps. Sure I'll do my best."],
		 [eColor, "Your best? We don't need you sleeping on this one."],
		 [oColor, "But I really wanted a nap... zzz ..."]],
"endText" : [[eColor, "See Olaf, was that so hard?"],
			[oColor, "I really still rather wanted a nap."]]},
{"level" : "res://Levels/Chansey_Levels/Level4.tscn",
 "name" : "MIXD",
"text" : [[oColor, "This seems more like a level for me."],
		 [bColor, "What do you mean, this seems like the level just before."],
		 [oColor, "Trust me on this one, I can carry this level for sure!"]],
"endText" : [[eColor, "I never seen anyone consume so much sugar at once."],
		 [bColor, "Dibs on the drums if he passes away from it."],
		 [oColor, "You already know I am just big boned."]]},
{"level" : "res://Levels/Chansey_Levels/Level5.tscn",
 "name" : "CHAI",
"text" : [],
"endText" : [[eColor, "Have you ever thought about how these bubbles even work."],
		 [bColor, "You do know we are in a video game right."],
		 [eColor, "Producers already told you to stay to the script."],
		 [narratorColor, "Cut. Take it from the top."]]},
{"level" : "res://Levels/Chansey_Levels/Level6_2.tscn",
 "name" : "TIME",
"text" : [[narratorColor, "Alright, this time you gotta go fast."],
		 [oColor, "I'd rather be strong like Thor."],
		 [eColor, "Balerog, how did you miss that reference, that game is even older than ours."],
		 [bColor, "He's too slow!"]],
"endText" : []},
{"level" : "res://Levels/Chansey_Levels/Level7.tscn",
 "name" : "SENS",
"text" : [],
"endText" : [[bColor, "Next time could you avoid dropping a block so close to my head!"],
		 [oColor, "We could also just have left you here forever."],
		 [bColor, "Sounds good, then we could maybe find more stuff from the sequal."],
		 [eColor, "Would be great having someone else not being stuck to the ground."]]},
{"level" : "res://Levels/Chansey_Levels/Level8.tscn",
 "name" : "BONK",
"text" : [[eColor, "Well your still here. I had just my hopes high."],
		 [oColor, "So which were you hoping for? The odd deer or the angry lizard?"],
		 [eColor, "Both."],
		 [bColor, "Remind me next hunt to just leave you behind in the forest."]],
"endText" : []},
{"level" : "res://Levels/Chansey_Levels/Level9.tscn",
 "name" : "FANS",
"text" : [],
"endText" : [[eColor, "I sure need to visit this level again, what a coaster."],
		 [oColor, "Then you gotta do it alone as I don't want to be captive again."],
		 [eColor, "Don't be such a bore. Wasn't the flight really fun."],
		 [oColor, "Let's just grab our ship the next time."]]},
{"level" : "res://Levels/Chansey_Levels/Level11.tscn",
 "name" : "PRMD",
"text" : [[bColor, "Isn't something wrong about the order here?"],
		 [eColor, "So long it is not the amazon again, I am fine with it."],
		 [oColor, "Can't we just get to the arctic next time. I much prefer the cold."],
		 [bColor, "I guess that would seem to much like home."]],
"endText" : []},
{"level" : "res://Levels/Chansey_Levels/Level12.tscn",
 "name" : "SYMB",
"text" : [[bColor, "This puzzle seems familiar."],
		 [eColor, "Maybe the solution is 1,2,2,3 again. I solved this a million times."],
		 [bColor, "Who remembers it like that? Spider, Flail, Weight and Eye you numbnut."]],
"endText" : [[oColor, "Wouldn't it just have been easier to test all options?"],
			 [eColor, "Where is your lust for adventure? Finding the solution is much more fun."],
			 [oColor, "Home like where I'd prefer to be right now."]]},
{"level" : "res://Levels/Chansey_Levels/Level10.tscn",
 "name" : "DROP",
"text" : [],
"endText" : []},
{"level" : "res://assets/Menu/end_credit.tscn",
 "name" : "Credit"}
]

var currentScene = 0
var musicEnabled = true
var soundEnabled = true
var textboxEnabled = true
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
const narratorColor = Color8(15, 15, 233)

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
	if textboxEnabled:
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
