extends Phase
class_name RollPhase

@export var min_roll: int = 1
@export var max_roll: int = 8
@onready var turn_manager = get_parent()

func Enter():
	print_debug("Entered Roll Phase")
	
func Update(delta: float):
	if Input.is_action_just_pressed("ui_accept"):
		_roll()
	
func _roll():
	var roll = randi_range(min_roll, max_roll)
	turn_manager.tiles_to_move = roll
	Transitioned.emit(self, "MovePhase")
	
	
	
