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
	if movement_type == MOVEMENT_TYPES.CARDINAL:
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
	print_debug("moving player", dir)
	await player.move_in_dir(dir, tiles_left)
	Transitioned.emit(self, "Roll")
