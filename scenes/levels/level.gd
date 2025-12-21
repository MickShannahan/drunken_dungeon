class_name Level extends Node2D

@onready var entrance_door := $LevelDoors/Entrance
@onready var exit_door := $LevelDoors/Exit
@export var exit_to_floor: PackedScene
@onready var player : Player = get_tree().get_first_node_in_group('Player')
@onready var player_cam: PlayerCamera = get_tree().get_first_node_in_group('Camera')

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if exit_to_floor:
		exit_door.exit_activated.connect(exit_to_next_floor)
	enter_into_level()

func enter_into_level():
	print('🏰 Entered Floor ' + self.name)
	player_cam.set_camera_limits($TileMapLayer)
	player.teleport_player_to_position(entrance_door.global_position)

func exit_to_next_floor():
	print('🚪 changing to ' + exit_to_floor.resource_path)
	if exit_to_floor:
		GlobalSceneController.change_floor(exit_to_floor.resource_path)
