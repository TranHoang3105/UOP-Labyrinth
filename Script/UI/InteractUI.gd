# Interact.gd - Attach to CanvasLayer root
extends CanvasLayer

@onready var control = $Control
@onready var label = $Control/Label

func _ready():
	# START HIDDEN
	hide_prompt()
	print("✅ Interact UI ready (hidden)")

func show_prompt(text: String = "Press E to interact"):
	label.text = text
	control.visible = true
	print("📱 Showing:", text)

func hide_prompt():
	control.visible = false
	print("📱 Hiding prompt")

# Optional: Fade animation
func show_prompt_with_fade(text: String):
	label.text = text
	control.visible = true
	control.modulate = Color(1, 1, 1, 0)
	
	var tween = create_tween()
	tween.tween_property(control, "modulate", Color.WHITE, 0.3)

func hide_prompt_with_fade():
	var tween = create_tween()
	tween.tween_property(control, "modulate", Color(1, 1, 1, 0), 0.3)
	tween.tween_callback(func(): control.visible = false)
