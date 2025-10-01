extends Node2D

signal hitEdge

func checkOverlap(area):
	for body in area.get_overlapping_bodies():
		if body is Tiles:
			return true
	return false

func _on_area_body_exited(body: Node2D) -> void:
	if body is Tiles:
		if !checkOverlap($LeftArea) or !checkOverlap($RightArea):
			hitEdge.emit()
