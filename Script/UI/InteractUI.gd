# SimpleInteractUI.gd
extends Control

@onready var label = $Label

func _ready():
	visible = false

func show_interact_prompt(title: String, requirement: int = 0):
	if requirement > 0:
		label.text = "%s\nNeed %d candy (You: %d)" % [title, requirement, GameManager.candy_count]
	else:
		label.text = title
	visible = true

func hide_interact_prompt():
	visible = false

func _on_candy_changed(new_count: int):
	if visible:
		# Just update the entire text
		show_interact_prompt("Trick or Treat!", 2)  # Hardcoded for testing
