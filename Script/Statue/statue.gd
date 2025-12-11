extends Node3D

@export var required_candy: int = 35
var candies_fed: int = 0
var player_in_range: bool = false

func _ready():
	add_to_group("fountain")
	print("✅ Successfully added to fountain group")
	print("⛲ Feed me ", required_candy, " candies to win!")
	
	# Create detection area for player proximity
	create_detection_area()
	
	# Make sure fountain has collision for raycast
	ensure_collision()

func create_detection_area():
	# Add Area3D for player detection (UI prompts)
	var area = Area3D.new()
	area.name = "DetectionArea"
	
	var collision = CollisionShape3D.new()
	collision.shape = BoxShape3D.new()
	collision.shape.size = Vector3(3, 3, 3)  # 3x3x3 meter area
	
	area.add_child(collision)
	area.body_entered.connect(_on_body_entered)
	area.body_exited.connect(_on_body_exited)
	add_child(area)
	
	print("✅ Created detection area")

func ensure_collision():
	# Make sure the fountain mesh has collision for raycast
	if has_node("MeshInstance3D"):
		var mesh = $MeshInstance3D
		# Create collision if it doesn't exist
		if mesh.get_child_count() == 0:  # No collision children
			mesh.create_convex_collision()
			print("✅ Added collision to fountain mesh")

func interact():
	print("=== FOUNTAIN INTERACTION ===")
	print("Candies fed:", candies_fed, "/", required_candy)
	print("Player candy:", GameManager.candy_count)
	
	if candies_fed >= required_candy:
		print("✅ Fountain is full! You should have won already!")
		return
	
	var candies_to_feed = min(GameManager.candy_count, required_candy - candies_fed)
	
	if candies_to_feed > 0:
		if GameManager.remove_candy(candies_to_feed):
			candies_fed += candies_to_feed
			print("⛲ Fed", candies_to_feed, " candy(s). Total:", candies_fed, "/", required_candy)
			
			if candies_fed >= required_candy:
				win_game()
		else:
			print("❌ Failed to remove candy from GameManager")
	else:
		print("❌ No candy to feed!")

func _on_body_entered(body):
	if body.is_in_group("player"):
		player_in_range = true
		print("🎯 Player entered fountain area")
		
		# Show UI prompt using UIManager
		if has_node("/root/UIManager"):
			UIManager.show_prompt("Press E to feed candy")
		else:
			print("📢 Press E to feed candy (UIManager not found)")

func _on_body_exited(body):
	if body.is_in_group("player"):
		player_in_range = false
		print("👋 Player left fountain area")
		
		# Hide UI prompt
		if has_node("/root/UIManager"):
			UIManager.hide_prompt()

func win_game():
	print("VICTORY! You fed the fountain", required_candy, "candies!")
	# Release mouse and go to victory screen
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().change_scene_to_file("res://Scene/Victory/VictoryScreen.tscn")

func get_remaining_candy() -> int:
	return max(0, required_candy - candies_fed)
