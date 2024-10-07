extends Node3D


var counter = 0
var max_counter = 0

signal victory

@onready var label = get_node(^"Container/Label")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var creatures = get_tree().get_nodes_in_group("creature")
	print(creatures)
	max_counter = len(creatures) / 2 # Note: creatures have root node and rigibody with group creature....


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func update_counter() -> void:
	counter += 1
	label.text = "Creatures found : %d / %d" % [counter, max_counter]
	
	if counter >= max_counter:
		emit_signal(&"victory")


func _on_player_creature_analised() -> void:
	print("called")
	update_counter()
