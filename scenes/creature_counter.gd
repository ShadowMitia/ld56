extends Node3D


var counter = 0

@onready var label = get_node(^"Container/Label")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func update_counter() -> void:
	counter += 1
	label.text = "Creatures found : %d" % counter


func _on_player_creature_analised() -> void:
	print("called")
	update_counter()
