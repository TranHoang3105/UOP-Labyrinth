@tool
extends MeshInstance3D

var locked_transform : Transform3D

func _ready():
	locked_transform = transform

func _process(delta):
	# Only run in editor
	if Engine.is_editor_hint():
		if transform != locked_transform:
			transform = locked_transform
