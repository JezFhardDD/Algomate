extends Control

# 🎛️ Node References
@onready var insert_button = $ButtonContainer/InsertButton
@onready var delete_button = $ButtonContainer/DeleteButton
@onready var traverse_button = $ButtonContainer/TraverseButton
@onready var code_button = $ButtonContainer/CodeButton
@onready var timeline_button = $ButtonContainer/TimelineButton
@onready var reset_button = $ButtonContainer/ResetButton

@onready var node_container = $NodeContainer
@onready var message_label = $MessageLabel

@onready var code_popup = $CodePopup
@onready var code_text = $CodePopup/VBoxContainer/CodeText
@onready var close_button = $CodePopup/VBoxContainer/CloseButton

@onready var timeline_popup = $TimelinePopup
@onready var timeline_text = $TimelinePopup/VBoxContainer/TimelineText
@onready var close_timeline_button = $TimelinePopup/VBoxContainer/CloseTimelineButton

# 🧱 Linked List Variables
var nodes: Array = []
@export var node_scene: PackedScene
const MAX_NODES = 7
var current_index: int = -1
var traversing: bool = false
var timeline_log: Array = []

# 🚀 Initialization
func _ready() -> void:
	print("🚀 Linked List Simulation Ready!")
	message_label.text = "Welcome to Linked List Simulator!"

	insert_button.pressed.connect(_on_insert_pressed)
	delete_button.pressed.connect(_on_delete_pressed)
	traverse_button.pressed.connect(_on_traverse_pressed)
	code_button.pressed.connect(_on_code_pressed)
	reset_button.pressed.connect(_on_reset_pressed)
	close_button.pressed.connect(_on_close_popup_pressed)

	timeline_button.pressed.connect(_on_timeline_pressed)
	close_timeline_button.pressed.connect(_on_close_timeline_pressed)

# ➕ INSERT
func _on_insert_pressed() -> void:
	if node_scene == null:
		_show_message("⚠️ No node scene assigned!")
		return

	if nodes.size() >= MAX_NODES:
		_show_message("⚠️ Maximum of %d nodes reached!" % MAX_NODES)
		return

	var new_node = node_scene.instantiate()
	node_container.add_child(new_node)
	new_node.set_value(nodes.size() + 1)
	new_node.can_flip = false
	nodes.append(new_node)
	_show_message("✅ Inserted node: %d" % nodes.size())
	_add_timeline_entry("Inserted Node %d" % nodes.size())

# 🗑️ DELETE
func _on_delete_pressed() -> void:
	if nodes.is_empty():
		_show_message("⚠️ No nodes to delete!")
		return

	var last_node = nodes.pop_back()
	last_node.queue_free()
	_show_message("🗑️ Deleted a node. Remaining: %d" % nodes.size())
	_add_timeline_entry("Deleted a node. Remaining: %d" % nodes.size())
	current_index = -1
	traversing = false

# 🔍 TRAVERSE
func _on_traverse_pressed() -> void:
	if nodes.is_empty():
		_show_message("⚠️ No nodes to traverse!")
		return

	if !traversing:
		traversing = true
		current_index = -1
		_show_message("🔍 Starting traversal... Press again to visit nodes.")
		_add_timeline_entry("Started traversal")

	current_index += 1
	for n in nodes:
		n.unhighlight()

	if current_index < nodes.size():
		var current_node = nodes[current_index]
		current_node.highlight()
		current_node.can_flip = true
		_show_message("👀 Visiting Node %d — Tap to reveal name!" % (current_index + 1))
		_add_timeline_entry("Visited Node %d" % (current_index + 1))
	else:
		_show_message("✅ Traversal complete! All nodes can now be flipped.")
		_add_timeline_entry("Traversal complete")
		traversing = false
		current_index = -1
		for n in nodes:
			n.can_flip = true

# 🔄 RESET
func _on_reset_pressed() -> void:
	if nodes.is_empty():
		_show_message("⚠️ Nothing to reset!")
		return
	for node in nodes:
		node.queue_free()
	nodes.clear()
	current_index = -1
	traversing = false
	_show_message("🔄 Linked List reset — all nodes cleared!")
	_add_timeline_entry("Reset simulation (cleared all nodes)")

# 💻 SHOW C++ CODE POPUP
func _on_code_pressed() -> void:
	code_text.text = get_hardcoded_cpp_code()
	code_popup.popup_centered_ratio(0.7)
	code_text.scroll_vertical = 0
	_show_message("💡 Showing hardcoded C++ code.")
	_add_timeline_entry("Viewed C++ code")

# ❌ CLOSE C++ POPUP
func _on_close_popup_pressed() -> void:
	code_popup.hide()
	_show_message("📄 Closed C++ code viewer.")

# 🕒 TIMELINE POPUP
func _on_timeline_pressed() -> void:
	var combined_log = ""
	for entry in timeline_log:
		combined_log += "• " + entry + "\n"
	timeline_text.text = combined_log if combined_log != "" else "No timeline entries yet."
	timeline_popup.popup_centered_ratio(0.7)
	_show_message("🕒 Viewing timeline.")

func _on_close_timeline_pressed() -> void:
	timeline_popup.hide()
	_show_message("📄 Closed timeline viewer.")

# 🧠 Add entry to timeline
func _add_timeline_entry(action: String) -> void:
	timeline_log.append(action)

# 💬 Show message
func _show_message(msg: String) -> void:
	message_label.text = msg
	print(msg)

# 🧩 Hardcoded C++ Code
func get_hardcoded_cpp_code() -> String:
	return """// Linked List Example (Insert, Delete, Traverse, Reset)
#include <iostream>
using namespace std;

struct Node {
    string name;
    Node* next;
};

class LinkedList {
private:
    Node* head;
public:
    LinkedList() { head = NULL; }

    void insert(string name) {
        Node* newNode = new Node();
        newNode->name = name;
        newNode->next = NULL;
        if (head == NULL)
            head = newNode;
        else {
            Node* temp = head;
            while (temp->next != NULL)
                temp = temp->next;
            temp->next = newNode;
        }
        cout << "Inserted: " << name << endl;
    }

    void deleteNode() {
        if (head == NULL) {
            cout << "List is empty!" << endl;
            return;
        }
        if (head->next == NULL) {
            delete head;
            head = NULL;
            cout << "Deleted last node" << endl;
            return;
        }
        Node* temp = head;
        while (temp->next->next != NULL)
            temp = temp->next;
        delete temp->next;
        temp->next = NULL;
        cout << "Deleted last node" << endl;
    }

    void traverse() {
        if (head == NULL) {
            cout << "List is empty!" << endl;
            return;
        }
        Node* temp = head;
        cout << "Traversal: ";
        while (temp != NULL) {
            cout << temp->name << " -> ";
            temp = temp->next;
        }
        cout << "NULL" << endl;
    }

    void reset() {
        while (head != NULL) {
            Node* temp = head;
            head = head->next;
            delete temp;
        }
        cout << "List reset (all nodes deleted)" << endl;
    }
};

int main() {
    LinkedList list;
    list.insert("Aiden");
    list.insert("Bianca");
    list.insert("Carlos");
    list.traverse();
    list.deleteNode();
    list.traverse();
    list.reset();
    return 0;
}
"""
