extends Phase
class_name MovePhase

enum MOVEMENT_TYPES {
	CARDINAL,
	DIAGONAL
}

var directions: Dictionary = {
	"up": Vector2(0, -1),
	"down": Vector2(0, 1),
	"left": Vector2(-1, 0),
	"right": Vector2(1, 0),
	"up_left": Vector2(-1, -1),
	"up_right": Vector2(1, -1),
	"down_left": Vector2(-1, 1),
	"down_right": Vector2(1, 1),
}

@export var player: Player
@onready var turn_manager: TurnManager = get_parent()
var tiles_to_move: int
var tiles_left: int
var movement_dir: Vector2
var movement_type: MOVEMENT_TYPES = MOVEMENT_TYPES.CARDINAL
var is_moving: bool = false
var available_directions: Array[String] = []

signal directions_available(directions: Array[String])


func Enter():
	tiles_to_move = turn_manager.tiles_to_move
	tiles_left = turn_manager.tiles_to_move
	movement_dir = turn_manager.movement_dir
	movement_type = MOVEMENT_TYPES.DIAGONAL if tiles_to_move % 2 == 1 else MOVEMENT_TYPES.CARDINAL
	_emit_available_directions()
	GlobalEmitter.emit('player_movement_start', [tiles_to_move])
	
func Update(_delta: float):
	if movement_type == MOVEMENT_TYPES.CARDINAL and !is_moving:
		if Input.is_action_just_pressed("ui_up"):
			_move_cardinal(directions.up)
		elif Input.is_action_just_pressed("ui_down"):
			_move_cardinal(directions.down)
		elif Input.is_action_just_pressed("ui_left"):
			_move_cardinal(directions.left)
		elif Input.is_action_just_pressed("ui_right"):
			_move_cardinal(directions.right)
	elif movement_type == MOVEMENT_TYPES.DIAGONAL and !is_moving:
		if Input.is_action_pressed("ui_up") and Input.is_action_pressed("ui_right"): # ↗️
			_move_diagonal(directions.up_right)
		elif Input.is_action_pressed("ui_up") and Input.is_action_pressed("ui_left"): # ↖️
			_move_diagonal(directions.up_left)
		elif Input.is_action_pressed("ui_down") and Input.is_action_pressed("ui_right"): # ↘️
			_move_diagonal(directions.down_right)
		elif Input.is_action_pressed("ui_down") and Input.is_action_pressed("ui_left"): # ↙️
			_move_diagonal(directions.down_left)

func _move_cardinal(dir: Vector2):
	print("🚶 Cardinal:", dir, movement_type)
	GlobalUi.clear_player_arrows.emit()
	GlobalUi.hide_player_roll_number.emit()
	is_moving = true
	movement_dir = dir
	
	while tiles_left > 0:
		# Check if we're hitting a wall in current direction
		if movement_dir == directions.left and player.left.is_colliding():
			print("⬅️ wall - waiting for new direction")
			is_moving = false
			_emit_available_directions()
			break
		elif movement_dir == directions.right and player.right.is_colliding():
			print("➡️ wall - waiting for new direction")
			is_moving = false
			_emit_available_directions()
			break
		elif movement_dir == directions.up and player.up.is_colliding():
			print("⬆️ wall - waiting for new direction")
			is_moving = false
			_emit_available_directions()
			break
		elif movement_dir == directions.down and player.down.is_colliding():
			print("⬇️ wall - waiting for new direction")
			is_moving = false
			_emit_available_directions()
			break
		
		# Move one tile in current direction
		var stop_movement = await move_player_one_unit(movement_dir)
		if stop_movement: tiles_left = 0
	
	# If we've used all tiles, end the movement phase
	if tiles_left <= 0:
		_end_movement_phase()

func _move_diagonal(dir: Vector2):
	print("🚶 Diagonal:", dir)
	GlobalUi.clear_player_arrows.emit()
	GlobalUi.hide_player_roll_number.emit()
	is_moving = true
	var moving_dir = dir
	
	while tiles_left > 0:
		# Handle cardinal directions first - these are the primary bounces
		if player.up.is_colliding() and moving_dir.y < 0:
			moving_dir.y = 1
		if player.down.is_colliding() and moving_dir.y > 0:
			moving_dir.y = -1
		if player.right.is_colliding() and moving_dir.x > 0:
			moving_dir.x = -1
		if player.left.is_colliding() and moving_dir.x < 0:
			moving_dir.x = 1
		
		# Then check diagonals only if they would block the NEW direction
		if player.up_left.is_colliding() and moving_dir == directions.up_left:
			moving_dir = directions.down_right
		if player.up_right.is_colliding() and moving_dir == directions.up_right:
			moving_dir = directions.down_left
		if player.down_left.is_colliding() and moving_dir == directions.down_left:
			moving_dir = directions.up_right
		if player.down_right.is_colliding() and moving_dir == directions.down_right:
			moving_dir = directions.up_left
		
		# Move one tile in current direction
		var stop_movement = await move_player_one_unit(moving_dir)
		if stop_movement: tiles_left = 0
	
	_end_movement_phase()
	
func move_player_one_unit(moving_dir: Vector2):
	tiles_left -= 1
	await player.move_one_unit(moving_dir)
	var stop_movement = await player.resolve_grid_space()
	GlobalEmitter.emit('player_moved_one_unit', [moving_dir])
	return stop_movement
	
func _end_movement_phase():
	print("movement over")
	is_moving = false
	GlobalEmitter.emit('player_movement_end')
	Transitioned.emit(self, "Roll")

func _emit_available_directions():
	_get_movement_options()
	GlobalUi.draw_player_arrows.emit(available_directions)
	
func _get_movement_options():
	available_directions.clear()
	if movement_type == MOVEMENT_TYPES.CARDINAL:
		if !player.up.is_colliding(): available_directions.append('up')
		if !player.down.is_colliding(): available_directions.append('down')
		if !player.left.is_colliding(): available_directions.append('left')
		if !player.right.is_colliding(): available_directions.append('right')
	else:
		if !player.up_left.is_colliding(): available_directions.append('up_left')
		if !player.up_right.is_colliding(): available_directions.append('up_right')
		if !player.down_left.is_colliding(): available_directions.append('down_left')
		if !player.down_right.is_colliding(): available_directions.append('down_right')
