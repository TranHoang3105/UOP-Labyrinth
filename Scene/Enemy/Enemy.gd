extends CharacterBody3D

var player = null
var hp = 15.0
var state_machine

const SPEED = 5.0
const ATTACK_RANGE = 3.0
const DAMAGE = 2.0

@export var player_path : NodePath

@onready var nav_agent = $NavigationAgent3D
@onready var animation_tree: AnimationTree = $AnimationTree

func _ready() -> void:
	player = get_node(player_path)
	state_machine = animation_tree.get("parameters/playback")

func _physics_process(_delta: float) -> void:
	if player == null:
		return

	# Always chase player
	nav_agent.set_target_position(player.global_position)
	var next_nav_point = nav_agent.get_next_path_position()

	velocity = (next_nav_point - global_position).normalized() * SPEED
	move_and_slide()

	# Animation logic
	if target_in_range():
		# Play sprint anim when attacking
		state_machine.travel("sprint")
	else:
		# Otherwise no animation (idle)
		state_machine.travel("idle")

func target_in_range() -> bool:
	return global_position.distance_to(player.global_position) <= ATTACK_RANGE
