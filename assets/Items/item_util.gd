extends Node2D

enum Item {none, raddish, bomb}

func imagePath(id):
	match id:
		Item.none:
			return "none"
		Item.raddish:
			return "food_raddish"
		Item.bomb:
			return "bomb"
