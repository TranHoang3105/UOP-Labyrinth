extends Area3D

# Make sure this path is correct for your project
func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.is_in_group("player"):
		print("Player touched water!")
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
		# Optional: Add a fade-out effect
		var tween = create_tween()
		tween.tween_interval(0.5)  # Wait half a second
		tween.tween_callback(func():
			get_tree().change_scene_to_file("res://Scene/Failure screen/Failurescreen.tscn")
		)
