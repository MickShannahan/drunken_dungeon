extends CanvasLayer

@onready var player: Player = get_tree().get_first_node_in_group("Player")

@onready var player_health_number: Label = $AsideContainer/Stats/Health/Number
@onready var player_gold_number: Label = $AsideContainer/Stats/Gold/Number

func _ready() -> void:
	player.player_damaged.connect(draw_player_stats)
	draw_player_stats(player.health)

func draw_player_stats(_health: int):
	print('drawing stats')
	player_health_number.text = str(player.health)
	player_gold_number.text = str(GameState.current_gold)
