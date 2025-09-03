extends KillArea

@export var Height = 1.0
@export var Width = 2.0

func _ready():
	$CollisionShape2D.shape.size.x = 46*Width
	$CollisionShape2D.shape.size.y = 46*Height
	$Sprite2D.region_rect.size.x = 46*Width
	$Sprite2D.region_rect.size.y = 46*Height
