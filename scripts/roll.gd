extends Phase
class_name RollPhase

@export var min_roll: int = 1
@export var max_roll: int = 8
@onready var turn_manager = get_parent()

func Enter():
	print("Entered Roll Phase")
	GlobalUi.clear_player_arrows.emit()
	GlobalUi.hide_player_roll_number.emit()
	GlobalUi.draw_player_roll_icon.emit(true)

func Exit():
	print("Exited Roll")
	
func Update(delta: float):
	if Input.is_action_just_pressed("ui_accept"):
		_roll_dice()
	
	
func _roll_dice():
	GlobalUi.draw_player_roll_icon.emit(false)
	var roll = randi_range(min_roll, max_roll)
	GlobalUi.show_player_roll_number.emit(roll)
	turn_manager.tiles_to_move = roll
	print("🎲", roll)
	Transitioned.emit(self, "Move")
