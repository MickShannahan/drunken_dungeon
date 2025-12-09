extends CenterContainer


@onready var player: Player = get_tree().get_first_node_in_group("Player")

var ui_arrows: Dictionary[String, Control]
var visible_arrows: Array[String]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_get_ui_node_arrows()
	show_arrows(["up_left", "down", "down_right"])

func _physics_process(_delta: float) -> void:
	var size_offset = get_rect().size / 2
	global_position = player.global_position - size_offset

func _get_ui_node_arrows():
	var arrow_nodes = $DirectionArrows.get_children()
	for node in arrow_nodes:
		if node is Control:
			var arrow = node.get_child(0)
			if arrow:
				arrow.visible = false
				ui_arrows[node.name] = arrow

func show_arrows(arrow_directions: Array[String]):
	for dir in arrow_directions:
		var arrow = ui_arrows.get(dir)
		if arrow:
			arrow.visible = true
