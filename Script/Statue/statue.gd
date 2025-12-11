# UltraSimpleFountain.gd
extends Node3D

@export var required_candy: int = 35
var candies_fed: int = 0

func _ready():
	add_to_group("fountain")
	print("Sucessfully added to fountain")
	print("⛲ Feed me ", required_candy, " candies to win!")

func interact():
	if candies_fed >= required_candy:
		print("✅ Fountain is full! You should have won already!")
		return
	
	var candies_to_feed = min(GameManager.candy_count, required_candy - candies_fed)
	
	if candies_to_feed > 0:
		GameManager.remove_candy(candies_to_feed)
		candies_fed += candies_to_feed
		print("⛲ Fed", candies_to_feed, " candy. Total:", candies_fed, "/", required_candy)
		
		if candies_fed >= required_candy:
			win_game()
	else:
		print("No candy to feed!")

func win_game():
	print("VICTORY! You fed the fountain 30 candies!")
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().change_scene_to_file("res://Scene/Victory/VictoryScreen.tscn")
