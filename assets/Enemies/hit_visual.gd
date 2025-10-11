extends Sprite2D

func _ready() -> void:
	get_tree().create_timer(0.7).timeout.connect(queue_free)

func _process(_delta):
	pass
