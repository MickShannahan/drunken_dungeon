extends Enemy

@onready var player: Player = get_tree().get_first_node_in_group('Player')
@export var movement_speed: int = 1

const TILE_SIZE: Vector2 = Vector2(16, 16)

func _ready():
	GlobalEmitter.connect_to_signal('player_movement_end', _follow_player)
	
func _follow_player():
	print('👻', player.global_position)
	
	for num in movement_speed:
		# Calculate direction towards player
		var direction_to_player = (player.global_position - global_position).normalized()
		
		# Determine which cardinal direction to move (prefer horizontal/vertical)
		var move_dir: Vector2
		if abs(direction_to_player.x) > abs(direction_to_player.y):
			# Move horizontally
			move_dir = Vector2(sign(direction_to_player.x), 0)
		else:
			# Move vertically
			move_dir = Vector2(0, sign(direction_to_player.y))
		
		# Move one tile in that direction
		var target_position = global_position + move_dir * TILE_SIZE
		var tween = create_tween()
		tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
		tween.tween_property(self, "global_position", target_position, 0.15).set_trans(Tween.TRANS_SINE)
		await tween.finished
