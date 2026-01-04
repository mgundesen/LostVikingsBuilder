extends Button

@export var iconPath = "res://assets/Menu/discordicon.png"
@export var link = "https://discord.gg/DZ5mZ6EDC6"

func _ready():
	icon = load(iconPath)

func _on_pressed() -> void:
	OS.shell_open(link)
