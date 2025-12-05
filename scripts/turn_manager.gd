extends Node
class_name TurnManager

@export var initial_phase: Phase
var phases : Dictionary = {}
var current_phase: Phase
var prev_phase : Phase

var tiles_to_move: int = 0
var movement_dir: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in get_children():
		if child is Phase:
			phases[child.name.to_lower()] = child
			child.Transitioned.connect(on_child_transition)
	if initial_phase:
		current_phase = initial_phase
		current_phase.Enter()
	print_debug('Phases Registered', phases)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if current_phase:
		current_phase.Update(delta)
		
func _physics_process(delta: float) -> void:
	if current_phase:
		current_phase.Physics_Update(delta)
	
func on_child_transition(phase: Phase, new_phase_name: String):
	print_debug("child transition: ", new_phase_name)
	
	var new_phase: Phase = phases.get(new_phase_name.to_lower())
	if !new_phase: return
	
	if current_phase:
		current_phase.Exit()
		
	new_phase.Enter()
