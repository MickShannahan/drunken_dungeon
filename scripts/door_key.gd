class_name DoorKey extends FloorEntity

@export var door_to_unlock : Door

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	entity_activated.connect(open_connected_door)
	if !door_to_unlock: 
		queue_free()

func activate(_activating_body: Node2D):
	print('overides work?')
	open_connected_door()

func open_connected_door():
	print('trying to open')
	if door_to_unlock:
		door_to_unlock.open_door()
		queue_free()
