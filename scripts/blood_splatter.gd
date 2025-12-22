extends CPUParticles2D

@export var timer: float = .1

func _ready() -> void:
	$Timer.wait_time = timer
	$Timer.start()

func _on_timer_timeout() -> void:
	set_process(false)
	set_physics_process(false)
	set_process_input(false)
	set_process_internal(false)
	set_process_unhandled_input(false)
	set_process_unhandled_key_input(false)
