extends Node3D

var total_time = 60

func _ready():
	# Display initial time
	$CanvasLayer/CountdownLabel.text = str(total_time)
	
	# Set text color to red
	$CanvasLayer/CountdownLabel.modulate = Color.RED
	
	# Start timing automatically when entering the scene
	$CountdownTimer.start()


func _process(_delta):
	if not $CountdownTimer.is_stopped():
		var left = int($CountdownTimer.time_left)
		$CanvasLayer/CountdownLabel.text = str(left)


func _on_CountdownTimer_timeout():
	print("Time Down！")
	# Write your logic after the countdown ends here.
