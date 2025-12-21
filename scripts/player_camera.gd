extends Camera2D

@onready var player: Player = get_tree().get_first_node_in_group("Player")
@onready var level: Node2D = get_tree().get_first_node_in_group("Level")
var camera_padding := 4 # number of tiles the camera pads the bounds

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if level:
		var tile_map: TileMapLayer = level.get_node('TileMapLayer')
		var bounding_box = tile_map.get_used_rect()
		var tile_size = tile_map.tile_set.tile_size.x
		# Convert tilemap coordinates to world pixels
		var level_top = bounding_box.position.y - (tile_size * 3)
		var level_bottom = ((bounding_box.position.y + bounding_box.size.y) * tile_size) + tile_size * 5
		
		# Get half the viewport size to center the camera properly
		var viewport_size = get_viewport_rect().size / 2
		
		# Set camera limits with viewport padding
		limit_top = int(level_top)
		limit_bottom = int(level_bottom)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if !$Deadzone.has_overlapping_areas():
		global_position.y = player.global_position.y
