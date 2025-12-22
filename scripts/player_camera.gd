class_name PlayerCamera extends Camera2D

@onready var player: Player = get_tree().get_first_node_in_group("Player")
@onready var level: Node2D = get_tree().get_first_node_in_group("Level")
@onready var main_ui = get_tree().get_first_node_in_group("MainGameUI")
var camera_padding := 1 # number of tiles the camera pads the bounds
var ui_width_offset := 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if main_ui:
		ui_width_offset = main_ui.size.x / 2.0
	set_camera_limits(level.get_node('TileMapLayer'))

func set_camera_limits(tile_map: TileMapLayer) -> void:
	if tile_map:
		var bounding_box = tile_map.get_used_rect()
		var tile_size = tile_map.tile_set.tile_size
		var tilemap_global_pos = tile_map.global_position
		
		# Convert tilemap coordinates to world pixels, accounting for tilemap's global position
		var level_top = tilemap_global_pos.y + (bounding_box.position.y * tile_size.y) - (camera_padding * tile_size.y)
		var level_bottom = tilemap_global_pos.y + ((bounding_box.position.y + bounding_box.size.y) * tile_size.y) + (camera_padding * tile_size.y)
		var level_left = tilemap_global_pos.x + (bounding_box.position.x * tile_size.x) - (camera_padding * tile_size.x)
		var level_right = tilemap_global_pos.x + ((bounding_box.position.x + bounding_box.size.x) * tile_size.x) + (camera_padding * tile_size.x)
		
		# Set camera limits to tilemap bounds
		limit_top = int(level_top)
		limit_bottom = int(level_bottom)
		limit_left = int(level_left)
		limit_right = int(level_right)
		
		print("🎥 Tilemap global pos: ", tilemap_global_pos, " Limits - top: ", limit_top, " bottom: ", limit_bottom, " left: ", limit_left, " right: ", limit_right)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if !$Deadzone.has_overlapping_areas():
		global_position.y = player.global_position.y
	
	# Offset camera horizontally by UI width
	global_position.x = player.global_position.x + ui_width_offset
	
	# Debug draw camera limits
	if OS.is_debug_build():
		queue_redraw()

func _draw() -> void:
	if OS.is_debug_build():
		var viewport_width = get_viewport_rect().size.x * 2 # Extend across full width
		var viewport_height = get_viewport_rect().size.y * 2 # Extend across full height
		var color = Color.from_rgba8(28, 146, 206, 52)
		
		draw_line(Vector2(-viewport_width, limit_top - global_position.y), Vector2(viewport_width, limit_top - global_position.y), color, 2.0)
		draw_line(Vector2(-viewport_width, limit_bottom - global_position.y), Vector2(viewport_width, limit_bottom - global_position.y), color, 2.0)
		draw_line(Vector2(limit_left - global_position.x, -viewport_height), Vector2(limit_left - global_position.x, viewport_height), color, 2.0)
		draw_line(Vector2(limit_right - global_position.x, -viewport_height), Vector2(limit_right - global_position.x, viewport_height), color, 2.0)
