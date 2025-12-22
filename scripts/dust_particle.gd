extends CPUParticles2D

@export var life_time: float = 0.2
@onready var player: Player = get_tree().get_first_node_in_group('Player')

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	lifetime = life_time
	one_shot = true
	$Timer.wait_time = life_time
	$Timer.start()
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	if player:
		global_position = player.global_position
	

func _on_timer_timeout() -> void:
	queue_free()
