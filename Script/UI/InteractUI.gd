extends Control

@onready var interact_label = $Panel/Label
@onready var panel = $Panel
@onready var timer_label = $Panel/RequirementLabel

func _ready():
	# Start hidden
	panel.visible = false

func show_interact_prompt(object_name: String, requirement: int = 0):
	interact_label.text = "Press E to interact with " + object_name
	
	if requirement > 0:
		var current_candy = GameManager.candy_count
		var candy_text = "Needs %d candy (You: %d)" % [requirement, current_candy]
		
		if current_candy >= requirement:
			timer_label.text = "[color=green]" + candy_text + "[/color]"
		else:
			timer_label.text = "[color=red]" + candy_text + "[/color]"
	else:
		timer_label.text = ""
	
	panel.visible = true

func hide_interact_prompt():
	panel.visible = false

func update_candy_display(requirement: int):
	if panel.visible and requirement > 0:
		var current_candy = GameManager.candy_count
		var candy_text = "Needs %d candy (You: %d)" % [requirement, current_candy]
		
		if current_candy >= requirement:
			timer_label.text = "[color=green]" + candy_text + "[/color]"
		else:
			timer_label.text = "[color=red]" + candy_text + "[/color]"
