class_name Coin extends FloorEntity

var pickup_effect : PackedScene = load('res://scenes/Particles/coin_pickup.tscn')


func activate(_activating_body: Node2D):
	GameService.modify_gold(1)
	play_pickup()
	queue_free()
	
func play_pickup():
	var pickup_instance = pickup_effect.instantiate()
	get_tree().get_first_node_in_group('Level').add_child(pickup_instance)
	pickup_instance.global_position = global_position
	
