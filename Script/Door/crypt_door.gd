extends StaticBody3D

@export var required_candy: int = 1 # Candy require to open the door 
var is_open: bool = false
var player_in_range: bool = false

func _ready():
	add_to_group("door")
	is_open = false
	
	# Add detection area
	var area = Area3D.new()
	var collision = CollisionShape3D.new()
	collision.shape = BoxShape3D.new()
	collision.shape.size = Vector3(2, 2, 2)  # Adjust size
	area.add_child(collision)
	area.body_entered.connect(_on_body_entered)
	area.body_exited.connect(_on_body_exited)
	add_child(area)

func _on_body_entered(body):
	if body.is_in_group("player"):
		player_in_range = true
		show_interact_prompt()

func _on_body_exited(body):
	if body.is_in_group("player"):
		player_in_range = false
		hide_interact_prompt()

func show_interact_prompt():
	var ui = get_tree().root.find_child("InteractUI", true, false)
	if ui:
		ui.show_interact_prompt("Trick or Treat!", required_candy)

func hide_interact_prompt():
	var ui = get_tree().root.find_child("InteractUI", true, false)
	if ui:
		ui.hide_interact_prompt()


func open_door():
	if not is_open:
		is_open = true
		print("Door opened!")
		
		# Get AnimationPlayer from parent (Node3D)
		if get_parent() and get_parent().has_node("AnimationPlayer"):
			var anim_player = get_parent().get_node("AnimationPlayer")
			if anim_player.has_animation("open"):
				anim_player.play("open")
		else:
			print("Could not find AnimationPlayer")
		
		# DISABLE COLLISION so player can walk through
		disable_collision()
		
		# Hide prompt when door opens
		hide_interact_prompt()

func disable_collision():
	collision_layer = 0
	collision_mask = 0
	print("Door collision disabled")
	
	if has_node("CollisionShape3D"):
		$CollisionShape3D.disabled = true
	if has_node("CollisionShape"):
		$CollisionShape.disabled = true
	

func try_open_with_candy(player_candy: int) -> bool:
	if player_candy >= required_candy:
		if GameManager.remove_candy(required_candy):
			open_door()
			return true
		else:
			print("Failed to feed the door candy!")
	
	print("The door demands ", required_candy, " candies! Trick or treat?")
	return false
