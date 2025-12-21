extends Camera2D

@onready var player: Player = get_tree().get_first_node_in_group("Player")
@onready var level: Node2D = get_tree().get_first_node_in_group("Level")
var camera_padding := 4 # number of tiles the camera pads the bounds

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_camera_limits(level.get_node('TileMapLayer'))

func set_camera_limits(tile_map: TileMapLayer) -> void:
	if tile_map:
		var bounding_box = tile_map.get_used_rect()
		var tile_size = tile_map.tile_set.tile_size.y
		var tilemap_global_y = tile_map.global_position.y
		
		# Convert tilemap coordinates to world pixels, accounting for tilemap's global position
		var level_top = tilemap_global_y + (bounding_box.position.y * tile_size)
		var level_bottom = tilemap_global_y + ((bounding_box.position.y + bounding_box.size.y) * tile_size)
		
		# Set camera limits to tilemap bounds
		limit_top = int(level_top)
		limit_bottom = int(level_bottom)
		# This is a comment here is another one
		
		print("🎥 Tilemap global Y: ", tilemap_global_y, " Limits - top: ", limit_top, " bottom: ", limit_bottom)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if !$Deadzone.has_overlapping_areas():
		global_position.y = player.global_position.y
	
	# Debug draw camera limits
	queue_redraw()

func _draw() -> void:
	var viewport_width = get_viewport_rect().size.x * 2 # Extend across full width
	var color = Color.RED
	
	# Draw top limit line
	draw_line(Vector2(-viewport_width, limit_top - global_position.y), Vector2(viewport_width, limit_top - global_position.y), color, 2.0)
	
	# Draw bottom limit line
	draw_line(Vector2(-viewport_width, limit_bottom - global_position.y), Vector2(viewport_width, limit_bottom - global_position.y), color, 2.0)
