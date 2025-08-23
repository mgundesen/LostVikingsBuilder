extends Node

func checkType(areaType, types):
	if types.size() == 0:
		return true
	for subType in types:
		if subType == areaType:
			return true
	return false

func isColliding(areaNode, types = []):
	for area in areaNode.get_overlapping_areas():
		if area is Hitbox:
			if checkType(area.type, types):
				area.queue_free()
				return true
	return false
