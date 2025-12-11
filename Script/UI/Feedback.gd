extends CanvasLayer

@onready var candy_feed_panel = $Control/Candy_FeedBack_Panel
@onready var candy_feed_label = $Control/Candy_FeedBack_Panel/Label
@onready var door_feed_panel = $Control/DoorFeedPanel
@onready var door_feed_label = $Control/DoorFeedPanel/Label
@onready var collection_panel = $Control/CollectionPanel
@onready var candy_collect_label = $Control/CollectionPanel/CandyLabel
@onready var time_collect_label = $Control/CollectionPanel/TimeLabel

var collection_timer: Timer
var feed_timer: Timer

func _ready():
	layer = 90  # Below Interact UI (which is 100)
	follow_viewport_enabled = true

	# Start hidden
	hide_all_panels()
	
	# Setup timers
	collection_timer = Timer.new()
	collection_timer.one_shot = true
	collection_timer.timeout.connect(_on_collection_timeout)
	add_child(collection_timer)
	
	feed_timer = Timer.new()
	feed_timer.one_shot = true
	feed_timer.timeout.connect(_on_feed_timeout)
	add_child(feed_timer)
	
	print("✅ FeedBackUI ready")

# ========== FOUNTAIN FEEDING ==========
func show_fountain_feedback(fed: int, total: int):
	candy_feed_label.text = "Fed: %d/%d" % [fed, total]
	
	# Position at top center
	candy_feed_panel.position = Vector2(get_viewport().size.x / 2 - 150, 50)
	candy_feed_panel.visible = true
	
	# Auto-hide after 3 seconds
	feed_timer.start(3.0)

# ========== DOOR USAGE ==========
func show_door_feedback(used: int, door_name: String = "Door"):
	door_feed_label.text = "Used %d candies on %s" % [used, door_name]
	
	# Position at top right
	door_feed_panel.position = Vector2(get_viewport().size.x - 250, 50)
	door_feed_panel.visible = true
	
	# Auto-hide after 2 seconds
	feed_timer.start(2.0)

# ========== CANDY COLLECTION ==========
func show_collection_feedback(candy_amount: int, time_amount: float):
	# Show candy collection feedback
	candy_collect_label.text = "+%d Candy" % candy_amount
	time_collect_label.text = "+%.0f Seconds" % time_amount
	
	# Position at bottom center (above interact prompt)
	collection_panel.position = Vector2(get_viewport().size.x / 2 - 100, 
									   get_viewport().size.y - 150)
	collection_panel.visible = true
	
	# Auto-hide after 1.5 seconds
	collection_timer.start(1.5)

# ========== TIMER CALLBACKS ==========
func _on_collection_timeout():
	collection_panel.visible = false

func _on_feed_timeout():
	candy_feed_panel.visible = false
	door_feed_panel.visible = false

func hide_all_panels():
	candy_feed_panel.visible = false
	door_feed_panel.visible = false
	collection_panel.visible = false

# Update positions on resize
func _on_viewport_resized():
	if candy_feed_panel.visible:
		candy_feed_panel.position = Vector2(get_viewport().size.x / 2 - 150, 50)
	if door_feed_panel.visible:
		door_feed_panel.position = Vector2(get_viewport().size.x - 250, 50)
	if collection_panel.visible:
		collection_panel.position = Vector2(get_viewport().size.x / 2 - 100,
										   get_viewport().size.y - 150)
