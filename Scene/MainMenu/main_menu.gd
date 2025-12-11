extends Control

func _ready():
	$VBoxContainer/Button_Start.pressed.connect(_on_start_pressed)
	$VBoxContainer/Button_Quit.pressed.connect(_on_quit_pressed)
	$VBoxContainer/Button_Guide.pressed.connect(_on_guide_pressed)

func _on_start_pressed():
	get_tree().change_scene_to_file("res://Scene/Map/Main_World.tscn")

func _on_quit_pressed():
	get_tree().quit()

func _on_guide_pressed():
	get_tree().change_scene_to_file("res://Scene/Guide/Guide.tscn")
