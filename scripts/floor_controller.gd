class_name FloorManager extends Node

@export var current_level : Node2D
@onready var world : Node = $World

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

	
func change_floor(floor_name: String):
	var next_floor_scene = load("res://scenes/levels/" + floor_name + ".tscn")
	var old_floor = world.get_node("Level")
	world.remove_child(old_floor)
	old_floor.call_deferred("free")
	world.add_child(next_floor_scene.instance())
