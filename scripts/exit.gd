class_name ExitDoor extends FloorEntity

signal exit_activated

func activate(_activating_body: Node2D):
		exit_activated.emit()
		return true
