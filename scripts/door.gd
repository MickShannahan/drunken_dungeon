class_name Door extends StaticBody2D

signal entity_activated(activated_by: Node2D)

func activate(activating_body: Node2D) -> bool:
	entity_activated.emit(activating_body)
	return false
	
func open_door():
	print('🔓Door Unlocked')
	queue_free()
