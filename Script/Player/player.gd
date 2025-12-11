extends CharacterBody3D

# Movement Variables
var speed
const WALK_SPEED = 5.0
const SPRINT_SPEED = 7.0
const JUMP_VELOCITY = 4.5
const SENS = 0.003

# Head Bob Variables
const BOB_FREQ = 2.0
const BOB_AMP = 0.08
var t_bob = 0.0

# References
@onready var head = $Head
@onready var camera = $Head/Camera3D
@onready var flashlight: Node3D = $Head/Flashlight

# Footstep sound references
@onready var walk_sound = $AudioStreamPlayer_walk
@onready var run_sound  = $AudioStreamPlayer_run

# Collect sound reference
@onready var collect_sound = $AudioStreamPlayer_collect  # AudioStreamPlayer 

# Interaction ray reference
@onready var interaction_ray = $Head/Camera3D/InteractionRay

# Ready
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	add_to_group("player")
	print("Player ready. Walk/Run sounds loaded.")
	
	# Make sure interaction ray is properly set up
	if interaction_ray:
		interaction_ray.enabled = true
		interaction_ray.collide_with_areas = true
		interaction_ray.collide_with_bodies = true
		print("Interaction ray initialized")
	else:
		print("Warning: Interaction ray not found!")

# Mouse Look
func _unhandled_input(event: InputEvent):
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * SENS)
		camera.rotate_x(-event.relative.y * SENS)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-40), deg_to_rad(60))

func _physics_process(delta: float) -> void:
	# Gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Sprint
	speed = SPRINT_SPEED if Input.is_action_pressed("sprint") else WALK_SPEED

	# Flashlight Toggle
	if Input.is_action_just_pressed("toggle"):
		flashlight.set_light()
		
	# Interaction (Press E)
	if Input.is_action_just_pressed("interaction"):
		try_interact()

	# Movement
	var input_dir = Input.get_vector("up", "down", "right", "left")
	var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = 0.0
		velocity.z = 0.0

	# Footstep Sounds
	if direction and is_on_floor():
		if speed == SPRINT_SPEED:
			play_run_sound()
		else:
			play_walk_sound()
	else:
		stop_footsteps()

	# Head Bob
	t_bob += delta * velocity.length() * float(is_on_floor())
	camera.transform.origin = _headbob(t_bob)

	move_and_slide()

# Head Bob Function
func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQ) * BOB_AMP
	return pos

# Footstep Sound Functions
func stop_footsteps():
	if walk_sound.playing:
		walk_sound.stop()
	if run_sound.playing:
		run_sound.stop()

func play_walk_sound():
	run_sound.stop()
	if not walk_sound.playing:
		walk_sound.play()

func play_run_sound():
	walk_sound.stop()
	if not run_sound.playing:
		run_sound.play()

func try_interact():		
	if interaction_ray and interaction_ray.is_colliding():
		var collider = interaction_ray.get_collider()
		print("🎯 Ray hit:", collider.name)
		
		# Check for fountain 
		if collider.is_in_group("fountain"):
			print("Found magical fountain!")
			interact_with_fountain(collider)
			
		elif collider.is_in_group("door"):
			# Halloween door interaction
			print("Saying 'Trick or Treat!' to the door...")
			if collider.has_method("try_open_with_candy"):
				var success = collider.try_open_with_candy(GameManager.candy_count)
				if success and collect_sound:
					collect_sound.play()
			
		elif collider.is_in_group("candy"):
			# Candy collection
			print("🍬 Found candy!")
			collect_candy(collider)
			
		elif collider.is_in_group("candy_bowl"):
			# Bowl collection
			print("🥣 Found candy bowl!")
			collect_candy_bowl(collider)
			
		else:
			print("Object not in any known group:", collider.name)
	else:
		print("No object in sight to interact with")

# Fountain Interaction 
func interact_with_fountain(fountain):
	if fountain.has_method("interact"):
		print("🎯 Attempting to feed the fountain...")
		print("   Your candy:", GameManager.candy_count)
		fountain.interact()
	else:
		print("❌ Fountain doesn't have interact() method")

func add_time_with_candy_sound(seconds: float) -> void:
	TimerManager.add_time(seconds)
	if collect_sound:
		collect_sound.stop()
		collect_sound.play()
	print("🎵 Added ", seconds, " seconds and played candy sound!")

func collect_candy(candy_node):
	GameManager.add_candy(1)
	add_time_with_candy_sound(10.0)
	candy_node.queue_free()
	print("Collected 1 candy! +5 seconds")

func collect_candy_bowl(bowl_node):
	# Call the bowl's collect() method if it exists
	if bowl_node.has_method("collect"):
		var amount = bowl_node.collect()  # This handles everything
		print("Collected bowl with", amount, "candies!")
	else:
		# Fallback for old bowls
		var random_amount = randi_range(2, 6)
		GameManager.add_candy(random_amount)
		add_time_with_candy_sound(random_amount * 10.0)
		bowl_node.queue_free()
		print("Collected bowl with ", random_amount, " candies! +", random_amount * 5, " seconds")

# ============================================
# OPTIONAL: DEBUG FUNCTION
# ============================================

# Add this for testing - press P to print game state
func _input(event):
	if event.is_action_pressed("ui_page_up"):  # Press Page Up
		print("\n=== GAME STATE DEBUG ===")
		print("Candy:", GameManager.candy_count)
		print("Time:", TimerManager.get_current_time() if TimerManager else "N/A")
		print("Looking at:", 
			interaction_ray.get_collider().name if interaction_ray and interaction_ray.is_colliding() 
			else "Nothing")
		print("=======================\n")
