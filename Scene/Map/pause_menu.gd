extends CanvasLayer

var is_paused: bool = false

var btn_resume
var btn_main_menu
var btn_exit

func _ready() -> void:
	call_deferred("_init_pause_menu")

func _init_pause_menu() -> void:
	btn_resume = $VBoxContainer/Button_Resume
	btn_main_menu = $VBoxContainer/Button_MainMenu
	btn_exit = $VBoxContainer/Button_Exit

	# 暂停时仍执行 _process 和响应输入
	process_mode = Node.PROCESS_MODE_ALWAYS
	btn_resume.process_mode = Node.PROCESS_MODE_ALWAYS
	btn_main_menu.process_mode = Node.PROCESS_MODE_ALWAYS
	btn_exit.process_mode = Node.PROCESS_MODE_ALWAYS

	visible = false

	btn_resume.pressed.connect(_on_button_resume_pressed)
	btn_main_menu.pressed.connect(_on_button_main_menu_pressed)
	btn_exit.pressed.connect(_on_button_exit_pressed)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		toggle_pause()

func toggle_pause() -> void:
	is_paused = not is_paused
	get_tree().paused = is_paused
	visible = is_paused

	if is_paused:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		btn_resume.grab_focus()
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _on_button_resume_pressed() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	toggle_pause()

func _on_button_main_menu_pressed() -> void:
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().change_scene_to_file("res://Scene/MainMenu/MainMenu.tscn")

func _on_button_exit_pressed() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().quit()
