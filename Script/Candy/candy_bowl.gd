extends Node3D


@export var min_candy: int = 2
@export var max_candy: int = 6

var start_y: float
var collected: bool = false

func _ready():
	add_to_group("candy_bowl")
	start_y = global_position.y
	
	# Add an Area3D as child for collision detection
	var area = Area3D.new()
	var collision = CollisionShape3D.new()
	collision.shape = SphereShape3D.new()
	collision.shape.radius = 0.5
	area.add_child(collision)
	area.body_entered.connect(_on_body_entered)
	add_child(area)

func _on_body_entered(body):
	if body.is_in_group("player"):
		collect()

func collect():
	var random_amount = randi_range(min_candy, max_candy)
	# Add candy and time
	GameManager.add_candy(random_amount)
	TimerManager.add_time(random_amount * 5.0)
	
	print("Collected candy bowl! +", random_amount, " candy")
	queue_free()
	
	return random_amount
