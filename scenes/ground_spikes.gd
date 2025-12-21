extends FloorEntity

@export var damage: int = 3
@export var currently_on: bool = false

func _ready() -> void:
	entity_activated.connect(step_on_trap)

func activate(activating_body: Node2D):
	step_on_trap(activating_body)

func step_on_trap(player: Player):
	if !currently_on:
		turn_on()
	else :
		player.recieve_damage(damage)
		
func turn_on():
	$On.visible = true
	currently_on = true
