extends StaticBody3D

@export var required_candy: int = 2
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
		print("🎯 Player entered door area")
		UIManager.show_prompt("Press E to open door")

func _on_body_exited(body):
	if body.is_in_group("player"):
		player_in_range = false
		print("👋 Player left door area")
		UIManager.hide_prompt()


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
		UIManager.hide_prompt()

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
			#show_door_feedback(required_candy)
			return true
		else:
			print("Failed to feed the door candy!")
	
	print("The door demands ", required_candy, " candy! Trick or treat?")
	return false
