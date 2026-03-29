extends Control

# ==============================================
# CATEGORY TOPIC MAPPING
# ==============================================
const DS_TOPICS = [
	"array", "linked_list", "stack", "queue",
	"tree", "binary_tree", "binary_search_tree", "graph"
]
const SORT_TOPICS = [
	"bubble_sort", "selection_sort", "insertion_sort",
	"merge_sort", "quick_sort", "shell_sort", "linear_search"
]
const SEARCH_TOPICS = [
	"binary_search", "interpolation_search", "breadth_first_search"
]

# ==============================================
# PUZZLE LEVEL REQUIREMENTS
# Each milestone: total levels needed to reveal that piece
# Order: Piece8, Piece7, Piece6, Piece5, Piece4, Piece3, Piece2, Puzzle
# ==============================================
const PUZZLE_MILESTONES = [5, 11, 16, 22, 27, 33, 38, 45]
const PUZZLE_PIECES = [
	"res://assets/Puzzle/PuzzlePiece8.png",
	"res://assets/Puzzle/PuzzlePiece7.png",
	"res://assets/Puzzle/PuzzlePiece6.png",
	"res://assets/Puzzle/PuzzlePiece5.png",
	"res://assets/Puzzle/PuzzlePiece4.png",
	"res://assets/Puzzle/PuzzlePiece3.png",
	"res://assets/Puzzle/PuzzlePiece2.png",
	"res://assets/Puzzle/Puzzle.png"
]

# ==============================================
# NODE REFERENCES — Column 1 = DS, 2 = Sort, 3 = Search
# ==============================================
@onready var ds_easy_count    = $MainScroll/MarginContainer/MainVBox/progressreport/EASY/Easy/badge_count
@onready var ds_easy_bar      = $MainScroll/MarginContainer/MainVBox/progressreport/EASY/Easy/ProgressBar
@onready var ds_medium_count  = $MainScroll/MarginContainer/MainVBox/progressreport/MEDIUM/Medium/badge_count
@onready var ds_medium_bar    = $MainScroll/MarginContainer/MainVBox/progressreport/MEDIUM/Medium/ProgressBar
@onready var ds_hard_count    = $MainScroll/MarginContainer/MainVBox/progressreport/HARD/Hard/badge_count
@onready var ds_hard_bar      = $MainScroll/MarginContainer/MainVBox/progressreport/HARD/Hard/ProgressBar

@onready var sort_easy_count   = $MainScroll/MarginContainer/MainVBox/progressreport/EASY2/Easy/badge_count
@onready var sort_easy_bar     = $MainScroll/MarginContainer/MainVBox/progressreport/EASY2/Easy/ProgressBar
@onready var sort_medium_count = $MainScroll/MarginContainer/MainVBox/progressreport/MEDIUM2/Medium/badge_count
@onready var sort_medium_bar   = $MainScroll/MarginContainer/MainVBox/progressreport/MEDIUM2/Medium/ProgressBar
@onready var sort_hard_count   = $MainScroll/MarginContainer/MainVBox/progressreport/HARD2/Hard/badge_count
@onready var sort_hard_bar     = $MainScroll/MarginContainer/MainVBox/progressreport/HARD2/Hard/ProgressBar

@onready var search_easy_count   = $MainScroll/MarginContainer/MainVBox/progressreport/EASY3/Easy/badge_count
@onready var search_easy_bar     = $MainScroll/MarginContainer/MainVBox/progressreport/EASY3/Easy/ProgressBar
@onready var search_medium_count = $MainScroll/MarginContainer/MainVBox/progressreport/MEDIUM3/Medium/badge_count
@onready var search_medium_bar   = $MainScroll/MarginContainer/MainVBox/progressreport/MEDIUM3/Medium/ProgressBar
@onready var search_hard_count   = $MainScroll/MarginContainer/MainVBox/progressreport/HARD3/Hard/badge_count
@onready var search_hard_bar     = $MainScroll/MarginContainer/MainVBox/progressreport/HARD3/Hard/ProgressBar

# ==============================================
# PUZZLE NODES
# ==============================================
@onready var puzzle_image: TextureRect = $MainScroll/MarginContainer/MainVBox/PuzzleSection/PuzzleCenter/PuzzleImage
@onready var puzzle_help_button: Button = $MainScroll/MarginContainer/MainVBox/PuzzleSection/PuzzleHeader/PuzzleHelpButton
@onready var puzzle_help_popup: PopupPanel = $PuzzleHelpPopup
@onready var close_help_btn: Button = $PuzzleHelpPopup/TextureRect/VBoxContainer/CloseHelpButton

func _ready() -> void:
	_load_progress()
	_update_puzzle()
	
	# Connect puzzle help button
	if puzzle_help_button:
		puzzle_help_button.pressed.connect(_on_puzzle_help_pressed)
	
	# Connect close help button
	if close_help_btn:
		close_help_btn.pressed.connect(_on_close_help_pressed)
	
	# Hide popup initially
	if puzzle_help_popup:
		puzzle_help_popup.hide()

func _load_progress() -> void:
	var all_progress: Array = DB.get_all_progress()

	# Build a lookup dict: "topic_difficulty" -> row
	var lookup: Dictionary = {}
	for row in all_progress:
		var key = str(row["topic"]) + "_" + str(row["difficulty"])
		lookup[key] = row

	# Count completions per category per difficulty
	var ds_easy   = _count_completed(DS_TOPICS,     1, lookup)
	var ds_med    = _count_completed(DS_TOPICS,     2, lookup)
	var ds_hard   = _count_completed(DS_TOPICS,     3, lookup)
	var sort_easy = _count_completed(SORT_TOPICS,   1, lookup)
	var sort_med  = _count_completed(SORT_TOPICS,   2, lookup)
	var sort_hard = _count_completed(SORT_TOPICS,   3, lookup)
	var srch_easy = _count_completed(SEARCH_TOPICS, 1, lookup)
	var srch_med  = _count_completed(SEARCH_TOPICS, 2, lookup)
	var srch_hard = _count_completed(SEARCH_TOPICS, 3, lookup)

	var ds_max   = DS_TOPICS.size()
	var sort_max = SORT_TOPICS.size()
	var srch_max = SEARCH_TOPICS.size()

	# Update Data Structures column
	_set_badge(ds_easy_count,   ds_easy_bar,   ds_easy,  ds_max)
	_set_badge(ds_medium_count, ds_medium_bar, ds_med,   ds_max)
	_set_badge(ds_hard_count,   ds_hard_bar,   ds_hard,  ds_max)

	# Update Sorting column
	_set_badge(sort_easy_count,   sort_easy_bar,   sort_easy, sort_max)
	_set_badge(sort_medium_count, sort_medium_bar, sort_med,  sort_max)
	_set_badge(sort_hard_count,   sort_hard_bar,   sort_hard, sort_max)

	# Update Searching column
	_set_badge(search_easy_count,   search_easy_bar,   srch_easy, srch_max)
	_set_badge(search_medium_count, search_medium_bar, srch_med,  srch_max)
	_set_badge(search_hard_count,   search_hard_bar,   srch_hard, srch_max)

	print("[Progress] DS:     %d/%d | %d/%d | %d/%d" % [ds_easy, ds_max, ds_med, ds_max, ds_hard, ds_max])
	print("[Progress] Sort:   %d/%d | %d/%d | %d/%d" % [sort_easy, sort_max, sort_med, sort_max, sort_hard, sort_max])
	print("[Progress] Search: %d/%d | %d/%d | %d/%d" % [srch_easy, srch_max, srch_med, srch_max, srch_hard, srch_max])

func _count_completed(topics: Array, difficulty: int, lookup: Dictionary) -> int:
	var count = 0
	for topic in topics:
		var key = topic + "_" + str(difficulty)
		if lookup.has(key) and lookup[key]["has_completed"] == 1:
			count += 1
	return count

func _set_badge(count_label: Label, bar: ProgressBar, value: int, max_val: int) -> void:
	count_label.text = "%d/%d" % [value, max_val]
	bar.max_value = max_val
	bar.value = value

func _on_back_button_pressed() -> void:
	AudioManager.play_back_sound()
	SceneManager.go_back()

# ==============================================
# PUZZLE FUNCTIONS
# ==============================================
func _get_total_completed_levels() -> int:
	var all_progress: Array = DB.get_all_progress()
	var skipped = ["tree", "binary_tree", "binary_search_tree", "graph", "graph_tree_search"]
	var completed = 0
	
	for row in all_progress:
		if row["topic"] in skipped:
			continue
		if row["has_completed"] == 1:
			completed += 1
	
	return completed

func _update_puzzle() -> void:
	if not puzzle_image:
		return
	
	var total_completed = _get_total_completed_levels()
	var piece_index = -1
	
	# Find which milestone the user has reached
	for i in range(PUZZLE_MILESTONES.size()):
		if total_completed >= PUZZLE_MILESTONES[i]:
			piece_index = i
	
	# Update the puzzle image based on progress
	if piece_index == -1:
		# Less than 5 levels completed - show locked message or placeholder
		puzzle_image.texture = null
		puzzle_image.modulate = Color(0.5, 0.5, 0.5, 0.5)
		
		# Create or update a label showing required levels
		var lock_label = puzzle_image.get_node_or_null("LockLabel")
		if not lock_label:
			lock_label = Label.new()
			lock_label.name = "LockLabel"
			lock_label.text = "🔒\nComplete 5 levels\nto unlock first piece!"
			lock_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			lock_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
			lock_label.add_theme_font_override("font", load("res://assets/font/Planes_ValMore.ttf"))
			lock_label.add_theme_font_size_override("font_size", 24)
			lock_label.add_theme_color_override("font_color", Color(1, 1, 1, 1))
			puzzle_image.add_child(lock_label)
		lock_label.visible = true
	else:
		# Hide lock label if it exists
		var lock_label = puzzle_image.get_node_or_null("LockLabel")
		if lock_label:
			lock_label.visible = false
		
		# Show the appropriate piece
		var texture_path = PUZZLE_PIECES[piece_index]
		var texture = load(texture_path)
		if puzzle_image and texture:
			puzzle_image.texture = texture
			puzzle_image.modulate = Color(1, 1, 1, 1)
	
	print("[Puzzle] Total completed levels: %d, Piece index: %d, Milestone: %d" % 
		[total_completed, piece_index, PUZZLE_MILESTONES[piece_index] if piece_index >= 0 else 0])

func _on_puzzle_help_pressed() -> void:
	AudioManager.play_click_sound()
	if puzzle_help_popup:
		puzzle_help_popup.popup_centered()

func _on_close_help_pressed() -> void:
	AudioManager.play_click_sound()
	if puzzle_help_popup:
		puzzle_help_popup.hide()
