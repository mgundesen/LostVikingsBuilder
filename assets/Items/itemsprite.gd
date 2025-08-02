extends Sprite2D

var idMapping = ["none",
				 "food_raddish",
				 "bomb"]

func setIcon(id):
	var path = "res://assets/Items/{id}.png".format({"id": idMapping[id]})
	texture = load(path)
