extends Node2D

var random = RandomNumberGenerator.new()
var keyCombo = [0,0,0,0]

func symbolShower(index):
	return $Objects.find_child("SymbolShower{index}".format({"index": index+1}))

func symbolSelector(index):
	return $Objects.find_child("SymbolSelector{index}".format({"index": index+1}))

func _ready():
	random.randomize()
	for index in range(4):
		var keyVal = random.randi() % 4
		keyCombo[index] = keyVal
		symbolShower(index).setSprite(keyVal)

func checkCode():
	var solved = true
	for index in range(4):
		if keyCombo[index] != symbolSelector(index).currentKey:
			solved = false
			
	if solved:
		$Objects/Door.open()
	else:
		EnemyUtil.simpleHit($Objects/Button)
