extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var childern = get_children()
	for child in childern:
		child.visible = true
