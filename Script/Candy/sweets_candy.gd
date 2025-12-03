extends Node3D

@export var spin_speed: float = 2.0
@export var float_height: float = 0.2
@export var float_speed: float = 2.0

var start_y: float

func _ready():
	add_to_group("candy")
	start_y = global_position.y
	
	# Add an Area3D as child for collision detection
	var area = Area3D.new()
	var collision = CollisionShape3D.new()
	collision.shape = SphereShape3D.new()
	collision.shape.radius = 0.5
	area.add_child(collision)
	area.body_entered.connect(_on_body_entered)
	add_child(area)

func _process(delta):
	# Floating animation
	global_position.y = start_y + sin(Time.get_ticks_msec() * 0.001 * float_speed) * float_height
	
	# Spinning animation
	rotate_y(delta * spin_speed)

func _on_body_entered(body):
	if body.is_in_group("player"):
		collect()

func collect():
	# If you want automatic collection on touch
	GameManager.add_candy(1)
	TimerManager.add_time(10.0)
	print("🍬 Candy collected automatically!")
	queue_free()
