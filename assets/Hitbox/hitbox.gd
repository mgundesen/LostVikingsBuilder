extends Area2D

class_name Hitbox

enum Type {all, basic, colliding, breaking, explode, smartbomb}
var type = Type.basic

func despawn(time):
	# anchor seems to be this, so important connect is done in here so disconnected if other despawned the hitbox
	get_tree().create_timer(time).timeout.connect(func(): queue_free())
