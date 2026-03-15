extends Control

# ==============================================
# CATEGORY TOPIC MAPPING
# Matches the 3 columns in the scene:
#   Column 1 — Data Structures (max 8)
#   Column 2 — Sorting Algorithms (max 7)
#   Column 3 — Searching / Graph (max 3)
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
# NODE REFERENCES — Column 1 = DS, 2 = Sort, 3 = Search
# ==============================================
@onready var ds_easy_count    = $progressreport/EASY/Easy/badge_count
@onready var ds_easy_bar      = $progressreport/EASY/Easy/ProgressBar
@onready var ds_medium_count  = $progressreport/MEDIUM/Medium/badge_count
@onready var ds_medium_bar    = $progressreport/MEDIUM/Medium/ProgressBar
@onready var ds_hard_count    = $progressreport/HARD/Hard/badge_count
@onready var ds_hard_bar      = $progressreport/HARD/Hard/ProgressBar

@onready var sort_easy_count   = $progressreport/EASY2/Easy/badge_count
@onready var sort_easy_bar     = $progressreport/EASY2/Easy/ProgressBar
@onready var sort_medium_count = $progressreport/MEDIUM2/Medium/badge_count
@onready var sort_medium_bar   = $progressreport/MEDIUM2/Medium/ProgressBar
@onready var sort_hard_count   = $progressreport/HARD2/Hard/badge_count
@onready var sort_hard_bar     = $progressreport/HARD2/Hard/ProgressBar

@onready var search_easy_count   = $progressreport/EASY3/Easy/badge_count
@onready var search_easy_bar     = $progressreport/EASY3/Easy/ProgressBar
@onready var search_medium_count = $progressreport/MEDIUM3/Medium/badge_count
@onready var search_medium_bar   = $progressreport/MEDIUM3/Medium/ProgressBar
@onready var search_hard_count   = $progressreport/HARD3/Hard/badge_count
@onready var search_hard_bar     = $progressreport/HARD3/Hard/ProgressBar

func _ready() -> void:
	_load_progress()

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
