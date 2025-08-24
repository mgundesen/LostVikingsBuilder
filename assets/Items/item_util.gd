extends Node2D

enum Item {none, raddish, bomb, keyBlue, keyRed, keyYellow}
enum Keyhole{red, blue, yellow}

func imagePath(id):
	match id:
		Item.none:
			return "none"
		Item.raddish:
			return "food_raddish"
		Item.bomb:
			return "bomb"
		Item.keyBlue:
			return "key_blue"
		Item.keyRed:
			return "key_red"
		Item.keyYellow:
			return "key_yellow"
