extends PopupPanel

# Node references - UPDATED TO MATCH YOUR SCENE
@onready var language_label: Label = $Panel/VBoxContainer/TitleBar/LanguageLabel
@onready var output_text: RichTextLabel = $Panel/VBoxContainer/ContentContainer/OutputContainer/ScrollContainer/OutputText
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

func show_output(language: String, response: Dictionary, compiler_ref: Node = null, from_compiler_scene: bool = false):
	"""Show compilation output in the popup
	   from_compiler_scene: true if called from Compiler.tscn (portrait mode)
	"""
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
	
	# Check for errors - with proper type handling
	var has_error = response.has("error") and response.error != null and response.error != ""
	
	# Handle isCompiled - could be int or bool
	var compilation_failed = false
	if response.has("isCompiled"):
		var compiled_val = response["isCompiled"]
		if typeof(compiled_val) == TYPE_BOOL:
			compilation_failed = !compiled_val
		elif typeof(compiled_val) == TYPE_INT:
			compilation_failed = (compiled_val == 0)
	
	# Handle isExecutionSuccess - could be int or bool
	var execution_failed = false
	if response.has("isExecutionSuccess"):
		var exec_val = response["isExecutionSuccess"]
		if typeof(exec_val) == TYPE_BOOL:
			execution_failed = !exec_val
		elif typeof(exec_val) == TYPE_INT:
			execution_failed = (exec_val == 0)
	
	# Update output text
	if response.has("output") and response.output != null:
		if has_error or compilation_failed or execution_failed:
			output_text.text = "[color=yellow]Program output (may be incomplete):[/color]\n\n" + response.output
		else:
			output_text.text = response.output
	else:
		output_text.text = "[color=gray]No output generated[/color]"
	
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
	
	# Update stats
	if response.has("memory") and response.memory != null:
		memory_value.text = response.memory
	else:
		memory_value.text = "N/A"
	
	if response.has("cpuTime") and response.cpuTime != null:
		cpu_value.text = response.cpuTime
	else:
		cpu_value.text = "N/A"
	
	# Update status
	if status_value:
		if has_error or compilation_failed:
			status_value.text = "Failed"
			status_value.modulate = Color(1, 0.5, 0.5, 1)
		else:
			status_value.text = "Success"
			status_value.modulate = Color(0.5, 1, 0.5, 1)
	
	# Show appropriate tab based on error status
	if has_error:
		_on_error_tab_pressed()
	else:
		_on_output_tab_pressed()
	
	# Cache the result
	_cache_result(language, response)
	
	# Show popup
	self.popup()

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
		"cpu": response.get("cpuTime", ""),
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
	output_container.visible = true
	error_container.visible = false
	stats_container.visible = false
	
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
