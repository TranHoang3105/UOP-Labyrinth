extends Label

@export var failure_scene_path := "res://Scene/Failure screen/Failurescreen.tscn"

func _ready() -> void:
	add_theme_color_override("font_color", Color.RED)
	#update_display()
	
	# Connect to TimerManager
	TimerManager.time_updated.connect(_on_time_updated)
	TimerManager.game_over.connect(_on_game_over)

func _on_time_updated(current_time: float):
	text = format_time(current_time)
	
	# Change color based on time remaining
	if current_time < 60:
		add_theme_color_override("font_color", Color.RED)
	elif current_time < 120:
		add_theme_color_override("font_color", Color.ORANGE)
	else:
		add_theme_color_override("font_color", Color.WHITE)

func format_time(seconds: float) -> String:
	var minutes = int(seconds) / 60
	var secs = int(seconds) % 60
	return "%02d:%02d" % [minutes, secs]

func _on_game_over():
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().change_scene_to_file(failure_scene_path)
