extends Sprite2D

func setIcon(id):
	var path = "res://assets/Items/{id}.png".format({"id": ItemUtil.imagePath(id)})
	texture = load(path)
