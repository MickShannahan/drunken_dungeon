extends CPUParticles2D

@export var life_time: float = 1.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	lifetime = life_time
	one_shot = true
	$Timer.wait_time = life_time
	$Timer.start()


func _on_timer_timeout() -> void:
	queue_free()
