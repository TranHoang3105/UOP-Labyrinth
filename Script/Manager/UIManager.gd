extends Node

var interact_ui = null

func register_ui(ui_node: Node):
	interact_ui = ui_node
	print("UIManager registered:", ui_node.name)

func show_prompt(text: String):
	if interact_ui and interact_ui.has_method("show_prompt"):
		interact_ui.show_prompt(text)
	else:
		print("📢", text)

func hide_prompt():
	if interact_ui and interact_ui.has_method("hide_prompt"):
		interact_ui.hide_prompt()
		
# Add to your existing UIManager.gd:
func show_fountain_feedback(fed: int, total: int):
	print("📊 Fountain: %d/%d candies" % [fed, total])
	# You could add actual UI here

func show_door_feedback(used: int, door_name: String):
	print("🚪 Used %d candies on %s" % [used, door_name])

func show_collection_feedback(candy_amount: int, time_amount: float):
	print("🎯 +%d Candy, +%.0f Seconds" % [candy_amount, time_amount])
