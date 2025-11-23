extends Control

func _ready():
	$VBoxContainer/Button_MainMenu.pressed.connect(_on_start_pressed)
	$VBoxContainer/Button_Exit.pressed.connect(_on_quit_pressed)

func _on_start_pressed():
	get_tree().change_scene_to_file("res://Scene/MainMenu/MainMenu.tscn")

func _on_quit_pressed():
	get_tree().quit()
