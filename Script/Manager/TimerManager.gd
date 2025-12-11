extends Node

# Signals
signal time_added(seconds)
signal time_updated(current_time)
signal time_changed(new_time)
signal game_over()

# Timer Variables
@export var initial_time: float = 120  # 初始倒计时时间，可在 Inspector 修改
var current_time: float = initial_time
var max_time: float = 600.0      # 10 minutes max
var is_game_active: bool = true

func _ready():
	reset_timer()

func reset_timer():
	current_time = initial_time  # 重置为初始时间
	is_game_active = true
	time_updated.emit(current_time)  # 立即通知 Label
	print("⏰ Timer reset | Total: ", format_time(current_time))

func add_time(seconds: float):
	if not is_game_active:
		return
	
	current_time += seconds
	if current_time > max_time:
		current_time = max_time
	
	time_added.emit(seconds)
	time_updated.emit(current_time)
	time_changed.emit(current_time)
	
	print("⏰ +", seconds, "s | Total: ", format_time(current_time))

func _process(delta):
	if not is_game_active:
		return
	
	current_time -= delta
	
	if current_time <= 0:
		current_time = 0
		is_game_active = false
		game_over.emit()
		get_tree().call_deferred("change_scene_to_file", "res://Scene/Failure screen/Failurescreen.tscn")
	
	time_updated.emit(current_time)

func get_current_time() -> float:
	return current_time

func format_time(seconds: float) -> String:
	var minutes = int(seconds)/ 60
	var secs = int(seconds) % 60
	return "%02d:%02d" % [minutes, secs]

func pause_game():
	is_game_active = false

func resume_game():
	is_game_active = true
