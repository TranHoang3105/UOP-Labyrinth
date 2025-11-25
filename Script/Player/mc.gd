extends Node3D

@onready var yaw_node = $CamYaw
@onready var pitch_node = $CamYaw/CamPitch
@onready var camera = $CamYaw/CamPitch/Camera3D

var yaw : float = 0
var pitch : float = 0

var yaw_sens : float = 0.10
var pitch_sens : float = 0.10

var yaw_accel : float = 15
var pitch_accel : float = 15

var pitch_max : float = 75
var pitch_min : float = -55

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _input(event):
	if event is InputEventMouseMotion:
		yaw += -event.relative.x * yaw_sens
		pitch += event.relative.y * pitch_sens
		
func _physics_process(delta):
	pitch = clamp(pitch, pitch_min, pitch_max)
	yaw_node.rotation_degrees.y = lerp(yaw_node.rotation_degrees.y,yaw,yaw_accel * delta)
	pitch_node.rotation_degrees.x = lerp(yaw_node.rotation_degrees.x,pitch,pitch_accel * delta)
