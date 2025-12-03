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
@onready var interaction_ray = $Head/Camera3D/InteractionRay

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	add_to_group("player")
	
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
	if Input.is_action_pressed("sprint"):
		speed = SPRINT_SPEED
	else:
		speed = WALK_SPEED
	
	# Flashlight Toggle
	if Input.is_action_just_pressed("toggle"):
		flashlight.set_light()
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
	
	# Head Bob
	t_bob += delta * velocity.length() * float(is_on_floor())
	camera.transform.origin = _headbob(t_bob)
	
	move_and_slide()

func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQ) * BOB_AMP
	return pos

func try_interact():
	# Just use raycast for everything
	if interaction_ray.is_colliding():
		var collider = interaction_ray.get_collider()
		
		if collider.is_in_group("door"):
			if collider.has_method("try_open_with_candy"):
				collider.try_open_with_candy(GameManager.candy_count)
				
		elif collider.is_in_group("candy"):
			GameManager.add_candy(1)
			TimerManager.add_time(10.0)
			collider.queue_free()
			print("🍬 Collected candy! +10 seconds")
			
		elif collider.is_in_group("candy_bowl"):
			var random_amount = randi_range(3, 5)
			GameManager.add_candy(random_amount)
			TimerManager.add_time(random_amount * 10.0)
			collider.queue_free()
			print("🥣 Collected bowl! +", random_amount, " candy")

func collect_candy(candy_node):
	# Add 1 candy to inventory
	GameManager.add_candy(1)
	# Add 10 seconds to timer
	TimerManager.add_time(10.0)
	# Remove from scene
	candy_node.queue_free()
	print("🎵 Collected 1 candy! +10 seconds")

func collect_candy_bowl(bowl_node):
	# Random amount between 3-5
	var random_amount = randi_range(3, 5)
	# Add to inventory
	GameManager.add_candy(random_amount)
	# Add time (10 seconds per candy)
	TimerManager.add_time(random_amount * 10.0)
	# Remove from scene
	bowl_node.queue_free()
	print("🎵 Collected bowl with ", random_amount, " candies! +", random_amount * 10, " seconds")

func interact_with_door(door):
	# Check if it's a big door (requires 3 candy) or small door (requires 2)
	var required_candy = 2  # Default for small doors
	
	if door.has_method("get_required_candy"):
		required_candy = door.get_required_candy()
	elif door.has("required_candy"):
		required_candy = door.required_candy
	
	# Try to open the door
	if GameManager.candy_count >= required_candy:
		if GameManager.remove_candy(required_candy):
			if door.has_method("open_door"):
				door.open_door()
			print("🚪 Door opened! Used ", required_candy, " candies")
	else:
		print("❌ Need ", required_candy, " candies! You have: ", GameManager.candy_count)
