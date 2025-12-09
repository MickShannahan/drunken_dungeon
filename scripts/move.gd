extends Phase
class_name MovePhase

enum MOVEMENT_TYPES {
	CARDINAL,
	DIAGONAL
}

@export var player: Player
@onready var turn_manager:TurnManager = get_parent()
var tiles_to_move: int
var tiles_left: int
var movement_dir: Vector2
var movement_type: MOVEMENT_TYPES = MOVEMENT_TYPES.CARDINAL
var is_moving: bool = false

func Enter():
	print_debug(turn_manager)
	tiles_to_move = turn_manager.tiles_to_move
	tiles_left = turn_manager.tiles_to_move
	movement_dir = turn_manager.movement_dir
	movement_type = MOVEMENT_TYPES.DIAGONAL if tiles_to_move % 2 == 1 else MOVEMENT_TYPES.CARDINAL
	print_debug("Enter Movement, ttm, tl, md, mt", tiles_to_move, tiles_left, movement_dir, movement_type)
	
func Update(delta: float):
	
	if movement_type == MOVEMENT_TYPES.CARDINAL and !is_moving:
		if Input.is_action_just_pressed("ui_up"):
			_move_player(Vector2(0, -1))
		elif Input.is_action_just_pressed("ui_down"):
			_move_player(Vector2(0, 1))
		elif Input.is_action_just_pressed("ui_left"):
			_move_player(Vector2(-1, 0))
		elif Input.is_action_just_pressed("ui_right"):
			_move_player(Vector2(1, 0))
	else :
		if Input.is_action_just_pressed("ui_up") and Input.is_action_just_pressed("ui_right"): # ↗️
			_move_player(Vector2(1, -1))
		elif Input.is_action_just_pressed("ui_up") and Input.is_action_just_pressed("ui_left"): # ↖️
			_move_player(Vector2(-1, -1))
		elif Input.is_action_just_pressed("ui_down") and Input.is_action_just_pressed("ui_right"): # ↘️
			_move_player(Vector2(1, 1))
		elif Input.is_action_just_pressed("ui_down") and Input.is_action_just_pressed("ui_left"): # ↙️
			_move_player(Vector2(-1, 1))

func _move_player(dir: Vector2):
	is_moving = true
	var moving_dir = dir
	while tiles_left > 0:
		# ⬆️➡️⬇️⬅️ Handle cardinal directions first - these are the primary bounces
		if player.up.is_colliding() and moving_dir.y < 0:
			moving_dir.y = 1
		if player.down.is_colliding() and moving_dir.y > 0:
			moving_dir.y = -1
		if player.right.is_colliding() and moving_dir.x > 0:
			moving_dir.x = -1
		if player.left.is_colliding() and moving_dir.x < 0:
			moving_dir.x = 1
		
		# ↗️↘️↙️↖️ Then check diagonals only if they would block the NEW direction
		if player.up_left.is_colliding() and moving_dir.x < 0 and moving_dir.y < 0:
			moving_dir.y = 1
			moving_dir.x = 1
		if player.up_right.is_colliding() and moving_dir.x > 0 and moving_dir.y < 0:
			moving_dir.y = 1
			moving_dir.x = -1
		if player.down_left.is_colliding() and moving_dir.x < 0 and moving_dir.y > 0:
			moving_dir.y = -1
			moving_dir.x = 1
		if player.down_right.is_colliding() and moving_dir.x > 0 and moving_dir.y > 0:
			moving_dir.y = -1
			moving_dir.x = -1
			
		if movement_type == MOVEMENT_TYPES.CARDINAL:
			if movement_dir.x < 0 and player.left.is_colliding():
				print_debug("⬅️ wall")
				is_moving = false
			elif movement_dir.x > 0 and player.right.is_colliding():
				print_debug("➡️ wall")
				is_moving = false
			elif movement_dir.y < 0 and player.up.is_colliding():
				print_debug("⬆️ wall")
				is_moving = false
			elif movement_dir.y > 0 and player.down.is_colliding():
				print_debug("⬇️ wall")
				is_moving = false
		
		if is_moving:
			tiles_left -= 1
			await player.move_one_unit(moving_dir)
			await player.resolve_grid_space()
		else:
			print_debug("movement paused", tiles_left)
			return
	
	_end_movement_phase()
	
func _end_movement_phase():
	print_debug("movement over")
	is_moving = false
	Transitioned.emit(self, "Roll")
