extends CharacterBody3D

@onready var camera_mount = $camera_mount
@onready var animation_player: AnimationPlayer = $CollisionShape3D/Visual/mixamo_base/AnimationPlayer
@onready var visual: Node3D = $CollisionShape3D/Visual



var SPEED = 3.0
const JUMP_VELOCITY = 4.5
var sens_horizontal = 0.5

var walking_speed = 3.0
var running_speed = 5.0

var running = false;

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(event.relative.x * sens_horizontal))
		visual.rotate_y(deg_to_rad(-event.relative.x * sens_horizontal))
		#$camera_mount.rotate_x(-deg_to_rad(event.relative.y * sens_horizontal))
		
		
func _physics_process(delta: float) -> void:
		
	if Input.is_action_just_pressed("sprint"):
		SPEED = running_speed
		running = true
	else:
		SPEED = walking_speed	
		running = false
	
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		if running:
			if animation_player.current_animation != "running":
				animation_player.play("running")
		else:
			if animation_player.current_animation != "walking":
				animation_player.play("walking")
			
		visual.look_at(position + direction)
		
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		if animation_player.current_animation != "idel":
			animation_player.play("idel")
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
