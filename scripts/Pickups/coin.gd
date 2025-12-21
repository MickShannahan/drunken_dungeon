class_name Coin extends FloorEntity


func activate(_activating_body: Node2D):
	GameService.modify_gold(1)
	queue_free()
