extends Node2D

func _ready():
	get_tree().create_timer(3.5).timeout.connect(func(): queue_free())
	$AudioStreamPlayer2D.play()

func _process(_delta):
	$AnimatedSprite2D.play("default")
	
