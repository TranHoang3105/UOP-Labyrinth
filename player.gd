extends CharacterBody3D

@export var speed := 6.0
@export var sprint_speed := 10.0
@export var acceleration := 8.0
@export var jump_force := 4.5
@export var gravity := 12.0

@export var camera: Node3D   # Drag your camera pivot here

var velocity_y := 0.0

func _physics_process(delta):
	if not camera:
		return

	# Gravity
	if not is_on_floor():
		velocity_y -= gravity * delta
	else:
		if Input.is_action_just_pressed("jump"):
			velocity_y = jump_force

	# Input vector
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")

	# Camera orientation helps movement
	var cam_forward = -camera.transform.basis.z
	var cam_right = camera.transform.basis.x

	var direction = (cam_forward * input_dir.y + cam_right * input_dir.x).normalized()

	# Sprint
	var target_speed = speed
	if Input.is_action_pressed("sprint"):
		target_speed = sprint_speed

	# Horizontal velocity
	var horizontal = velocity
	horizontal.y = 0

	if direction != Vector3.ZERO:
		horizontal = horizontal.lerp(direction * target_speed, acceleration * delta)
	else:
		horizontal = horizontal.lerp(Vector3.ZERO, acceleration * delta)

	velocity = horizontal
	velocity.y = velocity_y

	move_and_slide()
