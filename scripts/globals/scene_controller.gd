class_name SceneController extends Node

@export var floor: Node2D

var current_floor : Node2D
var current_gui : Control

func change_floor(new_floor_name: String, delete:= true, keep_running:= false):
	if current_floor != null:
		if delete:
			current_floor.queue_free()
		elif keep_running:
			current_floor.visible = false
		else:
			floor.remove_child(current_floor)
	var new_floor = load(new_floor_name)
	if new_floor:
		new_floor.instantiate()
		floor.add_child(new_floor)
		current_floor = new_floor
