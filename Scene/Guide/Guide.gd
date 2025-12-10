extends Control

func _ready():
	$VBoxContainer/Button_Quit.pressed.connect(_on_quit_pressed)

func _on_quit_pressed():
	get_tree().change_scene_to_file("res://Scene/MainMenu/MainMenu.tscn")
