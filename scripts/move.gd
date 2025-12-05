extends Phase
class_name MovePhase

var turn_manager:TurnManager = get_parent()
var tiles_to_move: int
var tiles_left: int
var movement_dir: Vector2

func Enter():
	tiles_to_move = turn_manager.tiles_to_move
	tiles_left = turn_manager.tiles_to_move
	movement_dir = turn_manager.movement_dir
