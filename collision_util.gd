extends Node

func isColliding(areaNode, type = Hitbox.Type.all):
	for area in areaNode.get_overlapping_areas():
		if area is Hitbox:
			if type == Hitbox.Type.all or area.type == type:
				area.queue_free()
				return true
	return false
