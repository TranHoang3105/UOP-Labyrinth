extends Node3D

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
		show_interact_prompt()

func _on_body_exited(body):
	if body.is_in_group("player"):
		player_in_range = false
		hide_interact_prompt()

func show_interact_prompt():
	var ui = get_tree().root.find_child("InteractUI", true, false)
	if ui:
		ui.show_interact_prompt("Door", required_candy)

func hide_interact_prompt():
	var ui = get_tree().root.find_child("InteractUI", true, false)
	if ui:
		ui.hide_interact_prompt()

func open_door():
	if not is_open:
		is_open = true
		print("🚪 Door opened!")
		
		if $AnimationPlayer.has_animation("open"):
			$AnimationPlayer.play("open")
		
		# Hide prompt when door opens
		hide_interact_prompt()

func try_open_with_candy(player_candy: int) -> bool:
	if player_candy >= required_candy:
		if GameManager.remove_candy(required_candy):
			open_door()
			return true
	
	print("❌ Need", required_candy, "candy")
	return false
