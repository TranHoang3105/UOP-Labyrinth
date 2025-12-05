extends AudioStreamPlayer

func _ready():
	if autoplay:  # 直接用节点自带的 autoplay
		play()

func _process(delta):
	if not playing:
		play()
