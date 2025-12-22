class_name FloorEntity extends Area2D

@export var entity_name: String

signal entity_activated(activated_by: Node2D)

func activate(activating_body: Node2D) -> bool:
	print("Activated:", entity_name)
	entity_activated.emit(activating_body)
	return false
