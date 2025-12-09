extends CharacterBody3D

var player = null
var hp = 15.0
var state_machine

const SPEED = 3.0
const ATTACK_RANGE = 3.0
const DAMAGE = 2.0
const DETECTION_RANGE = 15.0   # <-- Enemy begins chasing ONLY within this distance

@export var player_path : NodePath

@onready var nav_agent = $NavigationAgent3D
@onready var animation_tree: AnimationTree = $AnimationTree

func _ready() -> void:
	player = get_node(player_path)
	state_machine = animation_tree.get("parameters/playback")

func _physics_process(_delta: float) -> void:
	if player == null:
		return

	var distance = global_position.distance_to(player.global_position)

	# Only chase when the player is close enough
	if distance <= DETECTION_RANGE:
		nav_agent.set_target_position(player.global_position)
		var next_nav_point = nav_agent.get_next_path_position()

		velocity = (next_nav_point - global_position).normalized() * SPEED
		move_and_slide()

		# Animation logic
		if distance <= ATTACK_RANGE:
			state_machine.travel("sprint")   # attacking / rushing
		else:
			state_machine.travel("run")      # chasing but not attacking
	else:
		# Player is far → idle and stop moving
		velocity = Vector3.ZERO
		move_and_slide()
		state_machine.travel("idle")

func target_in_range() -> bool:
	return global_position.distance_to(player.global_position) <= ATTACK_RANGE
