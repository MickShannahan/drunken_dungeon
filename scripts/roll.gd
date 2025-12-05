extends Phase
class_name RollPhase

@export var min_roll: int = 1
@export var max_roll: int = 8
@onready var turn_manager = get_parent()

func Enter():
	print_debug("Entered Roll Phase")

func Exit():
	print_debug("Exited Roll")
	
func Update(delta: float):
	if Input.is_action_just_pressed("ui_accept"):
		_roll_dice()
	
	
func _roll_dice():
	var roll = randi_range(min_roll, max_roll)
	turn_manager.tiles_to_move = roll
	print_debug("🎲", roll)
	Transitioned.emit(self, "Move")
	
	
	
