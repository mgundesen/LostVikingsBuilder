extends Node2D

enum Item {none, raddish, tomato, bomb, keyBlue, keyRed, keyYellow, 
		   beef, smartbomb, fireArrow, gravboots, tools}
enum Keyhole{red, blue, yellow, machine}

func imagePath(id):
	match id:
		Item.none:
			return "none"
		Item.raddish:
			return "food_raddish"
		Item.tomato:
			return "food_tomato"
		Item.bomb:
			return "bomb"
		Item.keyBlue:
			return "key_blue"
		Item.keyRed:
			return "key_red"
		Item.keyYellow:
			return "key_yellow"
		Item.beef:
			return "beef"
		Item.smartbomb:
			return "smartbomb"
		Item.fireArrow:
			return "fire_arrow"
		Item.gravboots:
			return "gravboots"
		Item.tools:
			return "tools"
