class_name SceneController extends Node

var world: Node
var current_floor : Node2D
var current_gui : Control
var root := get_tree()

var current_game_scene: Node

func _ready() -> void:
	world =  get_node('/root/Game/World')
	if world:
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
		

func change_game_scene(new_scene_path: String, delete:=true, keep_running:=false):
	if current_game_scene != null:
		if delete:
			current_game_scene.queue_free()
		elif keep_running:
			current_game_scene.visible = false
		else: 
			get_tree().remove_child(current_game_scene)
			
	var new_game_scene = load(new_scene_path)
	if new_game_scene:
		var new_scene_instance = new_game_scene.instantiate()
		get_tree().change_scene_to_file("res://scenes/Game.tscn")
		current_game_scene = new_scene_instance
