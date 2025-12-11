extends CharacterBody3D

var player = null
var hp = 15.0

const SPEED = 5.0
const ATTACK_RANGE = 3.0
const DETECTION_RANGE = 15.0

@export var player_path : NodePath
@onready var nav_agent = $NavigationAgent3D

# Random respawn settings
@export var respawn_area_radius : float = 20.0  # Area around spawn point
@export var respawn_min_distance : float = 8  # Min distance from player
@export var respawn_area_center : Vector3 = Vector3.ZERO  # Center of respawn area
@export var use_random_respawn : bool = true  # Toggle random respawn

var spawn_position : Vector3
var can_attack := true   # cooldown lock


func _ready() -> void:
	player = get_node(player_path)
	spawn_position = global_position
	respawn_area_center = spawn_position  # Set respawn center to initial position
	
	# Initialize navigation map for random positions
	nav_agent.set_target_position(spawn_position)


func _physics_process(delta: float) -> void:
	if player == null:
		return

	if not can_attack:
		return   # waiting for cooldown after stealing

	var distance = global_position.distance_to(player.global_position)

	# Chase player when inside detection range
	if distance <= DETECTION_RANGE:

		nav_agent.set_target_position(player.global_position)
		var next_nav_point = nav_agent.get_next_path_position()

		var direction = next_nav_point - global_position
		direction.y = 0   # keep enemy at player eye level

		if direction.length() > 0.1:
			velocity = direction.normalized() * SPEED
		else:
			velocity = Vector3.ZERO

		velocity.y = 0
		move_and_slide()

		# Contact with player
		if distance <= ATTACK_RANGE:
			steal_and_respawn()
	else:
		velocity = Vector3.ZERO
		move_and_slide()


func get_random_respawn_position() -> Vector3:
	"""Get a random valid respawn position"""
	if not use_random_respawn:
		return spawn_position
	
	var attempts = 0
	var max_attempts = 10
	
	while attempts < max_attempts:
		# Generate random position within circle around center
		var random_angle = randf_range(0, 2 * PI)
		var random_distance = randf_range(respawn_min_distance, respawn_area_radius)
		
		var random_pos = Vector3(
			respawn_area_center.x + cos(random_angle) * random_distance,
			respawn_area_center.y,  # Keep same Y level
			respawn_area_center.z + sin(random_angle) * random_distance
		)
		
		# Check if position is far enough from player
		if player != null:
			var distance_to_player = random_pos.distance_to(player.global_position)
			if distance_to_player >= respawn_min_distance:
				return random_pos
		else:
			return random_pos
		
		attempts += 1
	
	# Fallback to original position if no valid position found
	print("Could not find valid random position, using original spawn")
	return spawn_position


func get_random_navigation_position() -> Vector3:
	"""Get a random position that's valid on the navigation mesh"""
	if not use_random_respawn:
		return spawn_position
	
	# Alternative: Use navigation mesh to find valid positions
	# You'll need to adjust this based on your navigation setup
	var nav_map = get_world_3d().navigation_map
	var query = NavigationServer3D.map_get_closest_point(nav_map, spawn_position)
	
	# Add some randomness
	var random_offset = Vector3(
		randf_range(-respawn_area_radius, respawn_area_radius),
		0,
		randf_range(-respawn_area_radius, respawn_area_radius)
	)
	
	var random_pos = query + random_offset
	
	# Snap to navigation mesh
	var valid_pos = NavigationServer3D.map_get_closest_point(nav_map, random_pos)
	
	return valid_pos


func steal_and_respawn():
	can_attack = false

	# Only steal if player has candy
	if GameManager.candy_count > 0:
		GameManager.add_candy(-1)
		print("Enemy stole 1 candy")
	else:
		print("Enemy tried to steal but player has no candy")

	# Get random respawn position
	var new_position = get_random_respawn_position()
	global_position = new_position
	print("Enemy respawned at: ", new_position)
	
	velocity = Vector3.ZERO
	nav_agent.set_target_position(new_position)

	# Cooldown before chasing again
	await get_tree().create_timer(1.5).timeout
	can_attack = true


func respawn_immediately():
	"""Public method to force respawn"""
	global_position = get_random_respawn_position()
	velocity = Vector3.ZERO
	nav_agent.set_target_position(global_position)
	print("Enemy forced to respawn at: ", global_position)
