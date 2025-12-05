extends Area2D


func _on_body_entered(body: Node2D) -> void:
	print_debug("coin got")
	_picked_up()

func _picked_up():
	queue_free()
