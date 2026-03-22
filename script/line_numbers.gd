extends RichTextLabel

@onready var code_editor: TextEdit = $"../../../CodeArea/CodeHBox/TextEdit"
var last_line_count: int = 0

func _ready():
	print("LineNumbers script started")
	print("My path: ", get_path())
	
	if code_editor == null:
		print("ERROR: Could not find TextEdit node!")
		return
	
	print("Found TextEdit: ", code_editor.name, " at path: ", code_editor.get_path())
	
	# Connect to text changes
	code_editor.text_changed.connect(_on_text_changed)
	
	# Connect to scrollbar changes
	var v_scroll = code_editor.get_v_scroll_bar()
	if v_scroll:
		v_scroll.value_changed.connect(_on_scroll_changed)
	
	# Initial update
	_update_line_numbers()

func _on_text_changed():
	_update_line_numbers()

func _on_scroll_changed(_value):
	# Update line numbers scroll position
	var scroll_line = code_editor.get_first_visible_line()
	self.scroll_to_line(scroll_line)

func _update_line_numbers():
	if code_editor == null:
		return
		
	var line_count = code_editor.get_line_count()
	
	# Only update if line count changed (performance optimization)
	if line_count != last_line_count:
		var line_numbers = ""
		for i in range(1, line_count + 1):
			line_numbers += str(i) + "\n"
		
		self.text = line_numbers
		last_line_count = line_count
