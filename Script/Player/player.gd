extends CharacterBody3D

# ---------------------
# Movement Variables
# ---------------------
var speed
const WALK_SPEED = 5.0
const SPRINT_SPEED = 7.0
const JUMP_VELOCITY = 4.5
const SENS = 0.003

# Head Bob Variables
const BOB_FREQ = 2.0
const BOB_AMP = 0.08
var t_bob = 0.0

# ---------------------
# References
# ---------------------
@onready var head = $Head
@onready var camera = $Head/Camera3D
@onready var flashlight: Node3D = $Head/Flashlight

# Footstep sound references
@onready var walk_sound = $AudioStreamPlayer_walk
@onready var run_sound  = $AudioStreamPlayer_run

# Collect sound reference
@onready var collect_sound = $AudioStreamPlayer_collect  # AudioStreamPlayer 

# ---------------------
# Ready
# ---------------------
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	add_to_group("player")
	print("Player ready. Walk/Run sounds loaded.")
	# collect_sound 不在这里播放，避免开场就响

# ---------------------
# Mouse Look
# ---------------------
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

func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQ) * BOB_AMP
	return pos

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
	print("🎵 Collected 1 candy! +10 seconds")

func collect_candy_bowl(bowl_node):
	var random_amount = randi_range(3, 5)
	GameManager.add_candy(random_amount)
	add_time_with_candy_sound(random_amount * 10.0)
	bowl_node.queue_free()
	print("🎵 Collected bowl with ", random_amount, " candies! +", random_amount * 10, " seconds")
