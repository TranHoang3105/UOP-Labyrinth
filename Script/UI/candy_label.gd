# CandyLabel.gd - Attach to LABEL (not ideal)
extends Label

func _ready():
	var game_manager = get_node("/root/GameManager")
	if game_manager:
		game_manager.candy_changed.connect(_on_candy_changed)
		text = "🍬x " + str(game_manager.candy_count)
	else:
		text = "🍬x 0"
		print("Can't find GameManager from Label")

func _on_candy_changed(new_count: int):
	text = "🍬x " + str(new_count)
