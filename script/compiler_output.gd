extends PopupPanel

# Node references - UPDATED TO MATCH YOUR SCENE
@onready var language_label: Label = $Panel/VBoxContainer/TitleBar/LanguageLabel
@onready var output_text: CodeEdit = $Panel/VBoxContainer/ContentContainer/OutputContainer/ScrollContainer/OutputText
@onready var error_text: RichTextLabel = $Panel/VBoxContainer/ContentContainer/ErrorContainer/ScrollContainer2/OutputText
@onready var memory_value: Label = $Panel/VBoxContainer/ContentContainer/StatsContainer/StatsGrid/MemoryValue
@onready var cpu_value: Label = $Panel/VBoxContainer/ContentContainer/StatsContainer/StatsGrid/CPUValue
@onready var status_value: Label = $Panel/VBoxContainer/ContentContainer/StatsContainer/StatsGrid/Label

# Tab references
@onready var output_tab: Button = $Panel/VBoxContainer/TabBar/OutputTab
@onready var error_tab: Button = $Panel/VBoxContainer/TabBar/ErrorTab
@onready var stats_tab: Button = $Panel/VBoxContainer/TabBar/StatsTab

# Container references
@onready var output_container: VBoxContainer = $Panel/VBoxContainer/ContentContainer/OutputContainer
@onready var error_container: VBoxContainer = $Panel/VBoxContainer/ContentContainer/ErrorContainer
@onready var stats_container: VBoxContainer = $Panel/VBoxContainer/ContentContainer/StatsContainer

# Button references
@onready var error_button: Button = $Panel/VBoxContainer/BottomBar/ErrorButton
@onready var bottom_close_button: Button = $Panel/VBoxContainer/BottomBar/CloseButton
@onready var top_close_button: Button = $Panel/VBoxContainer/TitleBar/CloseButton
@onready var recompile_button: Button = $Panel/VBoxContainer/BottomBar/RecompileButton

# Animation
@onready var error_anim: AnimatedSprite2D = $Panel/VBoxContainer/BottomBar/ErrorButton/AnimatedSprite2D

# Cache system
var cached_results: Dictionary = {}
var current_language: String = ""
var current_response: Dictionary = {}
var parent_compiler: Node = null

# Signals
signal recompile_requested(language: String)
signal closed()

func _ready():
	print("=== CompilerOutput Ready ===")
	print("Checking node references:")
	print("output_text: ", output_text)
	print("error_text: ", error_text)
	print("output_container: ", output_container)
	print("error_container: ", error_container)
	print("stats_container: ", stats_container)
	print("============================")
	
	# Make CodeEdit scrollable without text selection
	output_text.selecting_enabled = false
	output_text.context_menu_enabled = false
	output_text.editable = false
	
	# CRITICAL: Make sure the CodeEdit passes scroll events to the ScrollContainer
	output_text.mouse_filter = Control.MOUSE_FILTER_PASS  # Pass scroll events to parent
	
	# Also setup error text
	error_text.selection_enabled = false
	
	# Make scrollbars FAT for mobile touch (only call this once)
	_setup_mobile_friendly_scrolling()
	
	# Connect tab buttons
	if output_tab:
		output_tab.pressed.connect(_on_output_tab_pressed)
	if error_tab:
		error_tab.pressed.connect(_on_error_tab_pressed)
	if stats_tab:
		stats_tab.pressed.connect(_on_stats_tab_pressed)
	
	# Connect close buttons (both top and bottom)
	if bottom_close_button:
		bottom_close_button.pressed.connect(_on_close_pressed)
	if top_close_button:
		top_close_button.pressed.connect(_on_close_pressed)
	
	# Connect recompile button
	if recompile_button:
		recompile_button.pressed.connect(_on_recompile_pressed)
	
	# Connect error button
	if error_button:
		error_button.pressed.connect(_on_error_button_pressed)
	
	# Start with Output tab visible
	_on_output_tab_pressed()

func _setup_mobile_friendly_scrolling():
	"""Configure all scroll containers for mobile touch"""
	# Setup output scroll container
	var output_scroll = output_text.get_parent()
	if output_scroll is ScrollContainer:
		# Configure the ScrollContainer to handle touch scrolling
		output_scroll.scroll_deadzone = 20
		output_scroll.follow_focus = false
		output_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
		output_scroll.mouse_filter = Control.MOUSE_FILTER_STOP
		
		# Also make the scrollbar thicker
		_setup_scroll_container(output_scroll)
		
		print("Configured ScrollContainer for touch scrolling")
	
	# Also setup error scroll container if it exists
	var error_scroll = error_text.get_parent()
	if error_scroll is ScrollContainer:
		error_scroll.scroll_deadzone = 20
		error_scroll.follow_focus = false
		error_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
		error_scroll.mouse_filter = Control.MOUSE_FILTER_STOP
		
		# Also make the scrollbar thicker
		_setup_scroll_container(error_scroll)
		
		print("Configured error ScrollContainer for touch scrolling")

# Alternative: Require long-press for selection, swipe for scrolling
func _setup_touch_friendly_scrolling():
	# For CodeEdit
	output_text.selecting_enabled = true
	output_text.drag_and_drop_selection_enabled = false  # Disable drag-to-select
	
	# Increase the threshold for tap-and-hold to select
	# This makes quick swipes scroll, long presses select
	output_text.add_theme_constant_override("selection_drag_threshold", 20)
	
	# Disable touch selection handle for cleaner interface
	output_text.add_theme_constant_override("touch_selection_handle_size", 0)
	
func _setup_scroll_container(scroll_container: Node):
	"""Setup a scroll container with fat scrollbars - ALTERNATIVE APPROACH"""
	if not scroll_container is ScrollContainer:
		return
	
	# Configure scroll container for better touch scrolling
	scroll_container.scroll_deadzone = 20
	scroll_container.follow_focus = false
	scroll_container.mouse_filter = Control.MOUSE_FILTER_STOP
	
	# Try to set scrollbar width
	var v_scroll = scroll_container.get_v_scroll_bar()
	if v_scroll:
		# Try different methods to increase scrollbar width
		v_scroll.add_theme_constant_override("width", 45)
		v_scroll.add_theme_constant_override("grabber_width", 45)
		print("Set scrollbar width to 45 pixels")
		
		# Make scrollbar more visible
		var style = StyleBoxFlat.new()
		style.bg_color = Color(0.6, 0.6, 0.6, 0.9)
		style.set_corner_radius_all(8)
		v_scroll.add_theme_stylebox_override("grabber", style)
		
		var bg_style = StyleBoxFlat.new()
		bg_style.bg_color = Color(0.2, 0.2, 0.2, 0.5)
		bg_style.set_corner_radius_all(5)
		v_scroll.add_theme_stylebox_override("bg", bg_style)
	
	print("Setup scroll container")

func _make_text_edit_touch_friendly():
	"""Make CodeEdit more touch-friendly"""
	output_text.deselect_on_focus_loss = true
	output_text.scroll_past_end_of_file = true
	
	# Increase the caret width for better visibility
	output_text.add_theme_constant_override("caret_width", 3)
	
	# Make the selection easier to see
	output_text.add_theme_color_override("selection_color", Color(0.3, 0.6, 1.0, 0.5))

func show_output(language: String, response: Dictionary, compiler_ref: Node = null, from_compiler_scene: bool = false):
	print("=== SHOW_OUTPUT CALLED ===")
	print("Language: ", language)
	print("From compiler scene: ", from_compiler_scene)
	print("Response keys: ", response.keys())
	
	current_language = language
	current_response = response
	parent_compiler = compiler_ref
	
	# Set popup size based on source
	_set_popup_size(from_compiler_scene)
	
	# Update language label with color
	language_label.text = language.to_upper()
	match language:
		"cpp":
			language_label.modulate = Color(0.0117647, 0.478431, 0.623529, 1)
		"c":
			language_label.modulate = Color(0.531, 0.33, 1, 1)
		"java":
			language_label.modulate = Color(0.244373, 0.506155, 0.204431, 1)
		"python":
			language_label.modulate = Color(0, 0.67451, 0.627451, 1)
	
	# Ensure the output area is NOT editable by default (Read-Only Terminal)
	output_text.editable = false
	output_text.context_menu_enabled = true
	# Enable smooth scrolling and swiping
	output_text.wrap_mode = TextEdit.LINE_WRAPPING_BOUNDARY
	output_text.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART

	# Check for errors - with proper type handling
	var has_error = response.has("error") and response.error != null and response.error != ""
	print("Has error: ", has_error)
	
	# Handle isCompiled - could be int or bool
	var compilation_failed = false
	if response.has("isCompiled"):
		var compiled_val = response["isCompiled"]
		if typeof(compiled_val) == TYPE_BOOL:
			compilation_failed = !compiled_val
		elif typeof(compiled_val) == TYPE_INT:
			compilation_failed = (compiled_val == 0)
	print("Compilation failed: ", compilation_failed)
	
	# Handle isExecutionSuccess - could be int or bool
	var execution_failed = false
	if response.has("isExecutionSuccess"):
		var exec_val = response["isExecutionSuccess"]
		if typeof(exec_val) == TYPE_BOOL:
			execution_failed = !exec_val
		elif typeof(exec_val) == TYPE_INT:
			execution_failed = (exec_val == 0)
	print("Execution failed: ", execution_failed)
	
	# Update output text (CodeEdit/TextEdit version)
	var output_content = ""
	if response.has("output") and response.output != null:
		if has_error or compilation_failed or execution_failed:
			output_content = "Program output (may be incomplete):\n\n" + response.output
		else:
			output_content = response.output
	else:
		output_content = "No output generated"
	
	print("=== OUTPUT CONTENT DEBUG ===")
	print("Output content length: ", output_content.length())
	print("First 500 chars of output:")
	print(output_content.substr(0, 500))
	print("Last 500 chars of output:")
	print(output_content.substr(max(0, output_content.length() - 500)))
	print("============================")
	
	# Set the text
	output_text.text = output_content
	# DISABLE TEXT SELECTION - make it behave like a terminal that only scrolls
	output_text.selecting_enabled = false  # This prevents text selection entirely
	output_text.deselect()  # Clear any existing selection
	
	# Ensure the output area is NOT editable
	output_text.editable = false
	output_text.context_menu_enabled = false  # Disable right-click/long-press menu
	
	# Enable smooth scrolling and swiping
	output_text.wrap_mode = TextEdit.LINE_WRAPPING_BOUNDARY
	output_text.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	# Force a refresh
	output_text.queue_redraw()
	
	# Update error text
	if has_error:
		error_text.text = _format_error_message(response.error)
		error_button.visible = true
		if error_anim:
			error_anim.play("default")
	else:
		error_text.text = "[color=green]No compilation errors[/color]"
		error_button.visible = false
		if error_anim:
			error_anim.stop()
	
	# Update stats - Handle both "cpuTime" and "cpu" field names
	var cpu_time_str = "N/A"
	if response.has("cpuTime") and response.cpuTime != null:
		cpu_time_str = response.cpuTime
	elif response.has("cpu") and response.cpu != null:
		cpu_time_str = response.cpu
	print("CPU Time: ", cpu_time_str)
	
	if cpu_value:
		cpu_value.text = cpu_time_str
	
	# Memory field
	if response.has("memory") and response.memory != null:
		memory_value.text = response.memory
	else:
		memory_value.text = "N/A"
	
	# Update status
	if status_value:
		if has_error or compilation_failed:
			status_value.text = "Failed"
			status_value.modulate = Color(1, 0.5, 0.5, 1)
		else:
			status_value.text = "Success"
			status_value.modulate = Color(0.5, 1, 0.5, 1)
	
	# Show appropriate tab based on error status
	print("Showing tab - has_error: ", has_error)
	if has_error:
		_on_error_tab_pressed()
	else:
		_on_output_tab_pressed()
	
	# Cache the result
	_cache_result(language, response)
	
	# Debug: Check if output container is visible
	print("=== VISIBILITY DEBUG ===")
	print("Output container visible: ", output_container.visible)
	print("Error container visible: ", error_container.visible)
	print("Stats container visible: ", stats_container.visible)
	print("Output text visible: ", output_text.visible)
	print("Output text size: ", output_text.size)
	print("Output text line count: ", output_text.get_line_count())
	print("========================")
	
	# Show popup
	print("Showing popup...")
	self.popup()
	
	# Wait for popup to be fully shown
	await get_tree().process_frame
	await get_tree().process_frame
	
	# Debug after popup is shown
	print("=== AFTER POPUP SHOWN ===")
	print("Output text visible: ", output_text.visible)
	print("Output container visible: ", output_container.visible)
	print("Output text line count: ", output_text.get_line_count())
	print("=========================")
	
	# SOLUTION 1: Scroll to the TOP to show the beginning of the output
	print("Scrolling to top to show beginning of output...")
	if output_text and is_instance_valid(output_text):
		# Scroll to the first line to show the beginning
		output_text.set_caret_line(0)
		output_text.set_caret_column(0)
		output_text.center_viewport_to_caret()
		print("Scrolled to top - users can now scroll down to see the rest")
		
		# Optional: Print scroll position for debugging
		print("Current scroll position: ", output_text.get_v_scroll())
		print("Total lines: ", output_text.get_line_count())
	
	print("=== SHOW_OUTPUT COMPLETE ===")


func _enable_terminal_input():
	output_text.editable = true
	output_text.grab_focus()
	# Move cursor to the very end
	output_text.set_caret_line(output_text.get_line_count())
	
	# Connect the text_changed signal to detect 'Enter'
	if not output_text.text_changed.is_connected(_on_terminal_text_changed):
		output_text.text_changed.connect(_on_terminal_text_changed)

func _on_terminal_text_changed():
	# Detect if the user pressed 'Enter' on mobile/keyboard
	if output_text.text.ends_with("\n"):
		var full_text = output_text.text
		var lines = full_text.split("\n")
		var last_input = lines[lines.size() - 2] # The line just typed
		
		print("User Input detected: ", last_input)
		# Here you would send 'last_input' back to your compiler/backend
		output_text.editable = false
		
func _set_popup_size(from_compiler_scene: bool):
	"""Set popup size based on source scene"""
	if from_compiler_scene:
		# Called from Compiler.tscn - portrait mode
		# Size: width=642, height=800
		self.size = Vector2i(642, 800)
		
		# Center on screen
		var screen_size = DisplayServer.screen_get_size()
		self.position = Vector2i(
			(screen_size.x - 642) / 2,
			(screen_size.y - 800) / 2
		)
		
		print("Popup size set to portrait: 642×800")
	else:
		# Called from simulation scenes - landscape mode
		# Use 80% width, 60% height of screen
		var screen_size = DisplayServer.screen_get_size()
		var popup_size = Vector2i(
			int(screen_size.x * 0.8),
			int(screen_size.y * 0.6)
		)
		self.size = popup_size
		
		# Center the popup
		self.position = (screen_size - popup_size) / 2
		
		print("Popup size set to landscape: ", popup_size.x, "×", popup_size.y)

func _format_error_message(error_str: String) -> String:
	"""Format error message with nice highlighting"""
	var lines = error_str.split("\n")
	var formatted_lines = []
	
	for line in lines:
		if line.contains("error:"):
			formatted_lines.append("[color=red]" + line + "[/color]")
		elif line.contains("warning:"):
			formatted_lines.append("[color=yellow]" + line + "[/color]")
		elif line.contains("^"):
			formatted_lines.append("[color=cyan]" + line + "[/color]")
		else:
			formatted_lines.append(line)
	
	return "\n".join(formatted_lines)

func _cache_result(language: String, response: Dictionary):
	"""Cache compilation result"""
	cached_results[language] = {
		"output": response.get("output", ""),
		"error": response.get("error", ""),
		"memory": response.get("memory", ""),
		"cpu": response.get("cpuTime", response.get("cpu", "")),  # FIXED: Try cpuTime first, fallback to cpu
		"timestamp": Time.get_unix_time_from_system()
	}

func get_cached_result(language: String) -> Dictionary:
	"""Get cached result for a language"""
	if cached_results.has(language):
		return cached_results[language]
	return {}

func has_cached_result(language: String) -> bool:
	"""Check if language has cached result"""
	return cached_results.has(language)

func reset_cache():
	"""Clear all cached results"""
	cached_results.clear()
	print("CompilerOutput cache cleared")

func reset_cache_for_scene():
	"""Public method to reset cache (called from simulation scenes)"""
	reset_cache()

# Tab switching functions
func _on_output_tab_pressed():
	print("Switching to OUTPUT tab")
	output_container.visible = true
	error_container.visible = false
	stats_container.visible = false
	
	print("Output container now visible: ", output_container.visible)
	print("Output text has text length: ", output_text.text.length())
	print("Output text line count: ", output_text.get_line_count())
	
	# Update tab styles
	output_tab.disabled = true
	error_tab.disabled = false
	stats_tab.disabled = false

func _on_error_tab_pressed():
	output_container.visible = false
	error_container.visible = true
	stats_container.visible = false
	
	# Update tab styles
	output_tab.disabled = false
	error_tab.disabled = true
	stats_tab.disabled = false

func _on_stats_tab_pressed():
	output_container.visible = false
	error_container.visible = false
	stats_container.visible = true
	
	# Update tab styles
	output_tab.disabled = false
	error_tab.disabled = false
	stats_tab.disabled = true

# Button handlers
func _on_close_pressed():
	hide()
	closed.emit()

func _on_recompile_pressed():
	hide()
	recompile_requested.emit(current_language)

func _on_error_button_pressed():
	# Switch to error tab when error button is clicked
	_on_error_tab_pressed()
	
	# Stop animation if needed
	if error_anim:
		error_anim.stop()

# Handle popup visibility
func _notification(what):
	if what == NOTIFICATION_PREDELETE:
		closed.emit()
