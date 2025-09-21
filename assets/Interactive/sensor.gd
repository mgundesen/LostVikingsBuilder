extends Node2D

var count = 0

signal entered
signal exited

func _on_area_2d_body_entered(_body: Node2D) -> void:
	count += 1
	if count == 1:
		entered.emit()


func _on_area_2d_body_exited(_body: Node2D) -> void:
	count -= 1
	if count == 0:
		exited.emit()
