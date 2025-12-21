class_name SceneController extends Node

var world: Node
var current_floor : Node2D
var current_gui : Control

func _ready() -> void:
	world =  get_node('/root/Game/World')
	current_floor = world.get_node("Level")


func change_floor(new_floor_path: String, delete:= true, keep_running:= false):
	if current_floor != null:
		if delete:
			current_floor.queue_free()
		elif keep_running:
			current_floor.visible = false
		else:
			world.remove_child(current_floor)
	var new_floor_scene = load(new_floor_path)
	if new_floor_scene:
		var new_floor = new_floor_scene.instantiate()
		world.add_child(new_floor)
		current_floor = new_floor
