extends Label

@export var total_time: float = 60.0   # 测试用 5 秒
@export var failure_scene_path := "res://Scene/Failure screen/Failurescreen.tscn"

var remaining_time: float = 0.0
var is_paused: bool = false

func _ready() -> void:
	remaining_time = total_time
	add_theme_color_override("font_color", Color.RED)
	update_label()
	# 暂停时停止 _process
	process_mode = 0  # 0 = STOP, 1 = ALWAYS

func _process(delta: float) -> void:
	if is_paused:
		return

	remaining_time -= delta
	if remaining_time <= 0:
		remaining_time = 0
		update_label()
		go_to_failure_screen()
		return

	update_label()

func update_label() -> void:
	text = str(int(ceil(remaining_time)))

func go_to_failure_screen() -> void:
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().change_scene_to_file(failure_scene_path)
