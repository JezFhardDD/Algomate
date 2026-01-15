extends Control

# 🧩 Node paths
@onready var enqueue_btn: Button = $VBoxContainer/EnqueueButton
@onready var dequeue_btn: Button = $VBoxContainer/DequeueButton
@onready var waiting_btn: Button = $VBoxContainer/WaitingElements
@onready var dequeued_btn: Button = $VBoxContainer/DequeuedElements
@onready var timeline_btn: Button = $VBoxContainer/TimelineButton
@onready var simulate_new_btn: Button = $VBoxContainer/SimulateNew  # ✅ New button

@onready var enqueue_label: Label = $HBoxContainer/Label
@onready var dequeue_label: Label = $HBoxContainer2/Label
@onready var queue_container: Control = $QueueContainer

# Panels
@onready var waiting_popup: Popup = $WaitingPopup
@onready var waiting_label: Label = $WaitingPopup/VBoxContainer/Label
@onready var dequeued_container: Control = $DequeuedContainer
@onready var dequeued_close_btn: Button = dequeued_container.get_node_or_null("CloseButton")

# 🆕 Timeline popup
@onready var timeline_popup: Popup = $TimelinePopup
@onready var timeline_label: Label = $TimelinePopup/VBoxContainer/Label

# 🧱 Queue block scene
const BLOCK_SCENE := preload("res://QueueBlock.tscn")

# ⚙️ Settings
var MAX_QUEUE_SIZE: int = 5
var BLOCK_SPACING: float = 10.0
var START_POSITION: Vector2 = Vector2(80, 80)

# 📊 Runtime data
var queue: Array[int] = []
var waiting_elements: Array[int] = []
var dequeued_elements: Array[int] = []
var enqueue_counter: int = 0
var dequeue_counter: int = 0
var timeline_log: Array[String] = []

# 🎨 Colors
var colors: Array[Color] = [
	Color8(29, 209, 235),
	Color8(0, 128, 0),
	Color8(144, 238, 144),
	Color8(255, 230, 0),
	Color8(255, 165, 0),
	Color8(220, 53, 69)
]

# 🏁 Ready
func _ready() -> void:
	print("🚀 Program started — initializing queue visualizer...")
	randomize()
	MAX_QUEUE_SIZE = randi_range(5, 7)
	print("🎲 Max queue size for this session:", MAX_QUEUE_SIZE)
	$TextureRect/rear.visible = false
	$TextureRect/front.visible = false

	waiting_elements.clear()
	for i in range(MAX_QUEUE_SIZE):
		var val = randi_range(1, 99)
		waiting_elements.append(val)
		print("➕ Waiting element added:", val)

	dequeued_btn.pressed.connect(_on_dequeued_pressed)
	timeline_btn.pressed.connect(_on_timeline_pressed)
	simulate_new_btn.pressed.connect(_on_simulate_new_pressed)

	if dequeued_close_btn:
		dequeued_close_btn.pressed.connect(_on_dequeued_close_pressed)

	dequeued_container.hide()
	_update_labels()
	print("✅ Initialization complete — ready to simulate!\n")

# ➕ Enqueue
func _on_enqueue_pressed() -> void:
	print("➡️ Enqueue button pressed")
	$TextureRect/rear.visible = true
	$TextureRect/front.visible = true
	if queue.size() >= MAX_QUEUE_SIZE:
		print("❌ Queue full! Max size reached:", MAX_QUEUE_SIZE)
		return
	if waiting_elements.is_empty():
		print("⚠️ No waiting elements to enqueue.")
		return

	var new_val: int = waiting_elements.pop_front()
	queue.append(new_val)
	enqueue_counter += 1
	timeline_log.append("Enqueued %d" % new_val)
	print("🧱 Enqueued value:", new_val)

	var new_block: Control = BLOCK_SCENE.instantiate() as Control
	if new_block.has_method("set"):
		new_block.set("value", new_val)
	else:
		var lbl = new_block.get_node_or_null("NumberLabel")
		if lbl and lbl is Label:
			lbl.text = str(new_val)

	# ✅ Fixed assignment error here:
	if new_block.has_method("set_color"):
		new_block.set_color(colors[(queue.size() - 1) % colors.size()])
	else:
		var bg = new_block.get_node_or_null("Bg") as ColorRect
		if bg:
			bg.color = colors[(queue.size() - 1) % colors.size()]

	new_block.connect("block_dropped", Callable(self, "_on_block_dropped"))

	queue_container.add_child(new_block)
	_resnap_blocks()
	_update_labels()

# ➖ Dequeue
func _on_dequeue_pressed() -> void:
	print("⬅️ Dequeue button pressed")
	if queue.is_empty():
		print("⚠️ Queue is empty! Nothing to dequeue.")
		$TextureRect/rear.visible = false
		$TextureRect/front.visible = false
		return

	var removed_val: int = queue.pop_front()
	dequeue_counter += 1
	dequeued_elements.append(removed_val)
	timeline_log.append("Dequeued %d" % removed_val)
	print("🧹 Dequeued value:", removed_val)

	if queue_container.get_child_count() > 0:
		queue_container.get_child(0).queue_free()

	await get_tree().process_frame
	_shift_blocks_left()
	_update_labels()
	

# 👁️ Waiting popup
func _on_waiting_pressed() -> void:
	print("👀 Waiting elements button pressed")
	if waiting_popup.visible:
		waiting_popup.hide()
		print("❌ Closed WaitingPopup")
	else:
		if waiting_elements.is_empty():
			waiting_label.text = "No waiting elements."
			print("⚠️ No waiting elements left.")
		else:
			waiting_label.text = "Waiting Elements:\n" + ", ".join(waiting_elements.map(func(e): return str(e)))
			print("📋 Waiting elements shown:", waiting_elements)
		waiting_popup.popup_centered()

# 👁️ Timeline popup
func _on_timeline_pressed() -> void:
	print("🕓 Timeline button pressed")
	if timeline_popup.visible:
		timeline_popup.hide()
		print("❌ Closed TimelinePopup")
	else:
		if timeline_log.is_empty():
			timeline_label.text = "No events yet."
			print("⚠️ Timeline is empty.")
		else:
			timeline_label.text = "Timeline of Events:\n" + "\n".join(timeline_log)
			print("📜 Timeline opened with events:", timeline_log)
		timeline_popup.popup_centered()

# 👁️ Dequeued list
func _on_dequeued_pressed() -> void:
	print("📦 Dequeued elements button pressed")
	if dequeued_container.visible:
		dequeued_container.hide()
		print("❌ Closed DequeuedContainer")
	else:
		_refresh_dequeued_list()
		dequeued_container.show()
		print("📋 Showing dequeued elements:", dequeued_elements)
		$TextureRect/rear2.visible = true
		$TextureRect/front2.visible = true

func _on_dequeued_close_pressed() -> void:
	print("❌ DequeuedContainer closed")
	dequeued_container.hide()

# ♻️ Refresh dequeued list (hardcoded non-draggable)
func _refresh_dequeued_list() -> void:
	for child in dequeued_container.get_children():
		if child != dequeued_close_btn:
			child.queue_free()

	if dequeued_elements.is_empty():
		var lbl: Label = Label.new()
		lbl.text = "No dequeued elements yet."
		dequeued_container.add_child(lbl)
		print("📦 No dequeued elements to show.")
		return

	for i in range(dequeued_elements.size()):
		var value: int = dequeued_elements[i]
		var block := BLOCK_SCENE.instantiate() as Control

		var lbl := block.get_node_or_null("NumberLabel")
		if lbl and lbl is Label:
			lbl.text = str(value)

		var bg := block.get_node_or_null("Bg")
		if bg and bg is ColorRect:
			bg.color = colors[i % colors.size()]

		if block.get_script() != null:
			block.set_script(null)

		block.mouse_filter = Control.MOUSE_FILTER_IGNORE
		for c in block.get_children():
			if c is Control:
				c.mouse_filter = Control.MOUSE_FILTER_IGNORE

		block.modulate = Color(0.85, 0.85, 0.85, 1.0)
		dequeued_container.add_child(block)
		print("📦 Added static dequeued block:", value)

	print("📦 Dequeued blocks refreshed — non-draggable now.")

# 🔁 Update labels
func _update_labels() -> void:
	enqueue_label.text = "Enqueue Counter: %d" % enqueue_counter
	dequeue_label.text = "Dequeue Counter: %d" % dequeue_counter
	print("🔢 Counters updated: Enqueue =", enqueue_counter, "Dequeue =", dequeue_counter)

# 🧲 Handle block dropped
func _on_block_dropped(dropped_block: Control) -> void:
	var children: Array = queue_container.get_children()
	var old_index: int = children.find(dropped_block)
	var center_x: float = dropped_block.position.x + dropped_block.size.x * 0.5
	var insert_index: int = 0

	for c in children:
		if c == dropped_block:
			continue
		var c_center: float = c.position.x + c.size.x * 0.5
		if center_x > c_center:
			insert_index += 1

	if old_index == 0 and insert_index > 0:
		print("⚠️ FIFO rule: Can't move the front block!")
		dropped_block.position = dropped_block.original_position
		_resnap_blocks()
		return

	queue_container.move_child(dropped_block, insert_index)
	var moved_val: int = queue.pop_at(old_index)
	queue.insert(insert_index, moved_val)
	timeline_log.append("Moved %d from position %d → %d" % [moved_val, old_index, insert_index])
	print("🔀 Block moved:", moved_val, "from", old_index, "to", insert_index)
	_resnap_blocks()

# 🧩 Re-align all blocks neatly
func _resnap_blocks() -> void:
	var x = START_POSITION.x
	for child: Control in queue_container.get_children():
		child.position = Vector2(x, START_POSITION.y)
		child.original_position = child.position
		x += child.size.x + BLOCK_SPACING

# 🧱 Shift left after dequeue
func _shift_blocks_left() -> void:
	_resnap_blocks()

# 🔄 SimulateNew — Reset everything
func _on_simulate_new_pressed() -> void:
	print("🌀==============================")
	print("🔁 Simulation Restart Triggered!")
	print("🌀==============================")

	queue.clear()
	waiting_elements.clear()
	dequeued_elements.clear()
	timeline_log.clear()
	enqueue_counter = 0
	dequeue_counter = 0

	for child in queue_container.get_children():
		child.queue_free()
	for child in dequeued_container.get_children():
		if child != dequeued_close_btn:
			child.queue_free()

	MAX_QUEUE_SIZE = randi_range(5, 7)
	print("🎲 New max queue size =", MAX_QUEUE_SIZE)
	for i in range(MAX_QUEUE_SIZE):
		var new_val = randi_range(1, 99)
		waiting_elements.append(new_val)
		print("➕ Added waiting element:", new_val)

	_update_labels()
	if waiting_popup.visible:
		waiting_popup.hide()
	if timeline_popup.visible:
		timeline_popup.hide()
	if dequeued_container.visible:
		dequeued_container.hide()
	$TextureRect/rear.visible = false
	$TextureRect/front.visible = false
	$TextureRect/rear2.visible = false
	$TextureRect/front2.visible = false

	var log_message = "Simulation restarted with %d new waiting elements." % MAX_QUEUE_SIZE
	timeline_log.append(log_message)
	print("📜", log_message)
	print("✅ Simulation fully reset and ready!")
	print("🌀==============================\n")
