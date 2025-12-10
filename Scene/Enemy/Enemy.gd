extends CharacterBody3D

var player = null
var hp = 15.0

const SPEED = 5.0
const ATTACK_RANGE = 3.0
const DETECTION_RANGE = 15.0

@export var player_path : NodePath
@onready var nav_agent = $NavigationAgent3D

var spawn_position
var can_attack := true   # cooldown lock


func _ready() -> void:
	player = get_node(player_path)
	spawn_position = global_position


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
			steal_and_reset()
	else:
		velocity = Vector3.ZERO
		move_and_slide()


# Steal candy if possible and always reset enemy
func steal_and_reset():
	can_attack = false

	# Only steal if player has candy
	if GameManager.candy_count > 0:
		GameManager.add_candy(-1)
		print("Enemy stole 1 candy")
	else:
		print("Enemy tried to steal but player has no candy")

	# Always reset ghost position
	global_position = spawn_position
	velocity = Vector3.ZERO
	nav_agent.set_target_position(spawn_position)

	# Cooldown before chasing again
	await get_tree().create_timer(1.5).timeout
	can_attack = true
