extends Sprite2D

signal won
var transition = false

enum endState {notDone, won, wonButMissing}
func isDone():
	var state = endState.won
	for player in PlayerUtil.getPlayers():
		if player.playerHealth < 1 and state!= endState.notDone:
			state = endState.wonButMissing
		if player.playerHealth > 0 and player.position.distance_to(position) > 120:
			state = endState.notDone
	return state

func _process(_delta):
	if transition:
		return
	var winState = isDone()
	if winState == endState.notDone:
		return
	transition = true
	get_parent().get_parent().get_node("FadeScene").fadeout()
	if winState == endState.won:
		won.emit()
		get_tree().create_timer(0.5, false).timeout.connect(func(): SceneControl.nextScene())
	else:
		get_tree().create_timer(0.5, false).timeout.connect(func(): SceneControl.deathScene())
