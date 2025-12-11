extends CenterContainer


@onready var player: Player = get_tree().get_first_node_in_group("Player")

var ui_arrows: Dictionary[String, Control]
var visible_arrows: Array[String]
var show_roll_icon := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
#	ui for movement arrows
	_get_ui_node_arrows()
	show_arrows(["up_left", "down", "down_right"])
	GlobalUi.draw_player_arrows.connect(show_arrows)
	GlobalUi.clear_player_arrows.connect(clear_arrows)
#	connect roll ui
	GlobalUi.draw_player_roll_icon.connect(toggle_roll_icon)
	GlobalUi.show_player_roll_number.connect(show_roll_number)
	GlobalUi.hide_player_roll_number.connect(hide_roll_number)
	

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
	clear_arrows()
	for dir in arrow_directions:
		var arrow = ui_arrows.get(dir)
		if arrow:
			arrow.visible = true

func clear_arrows():
	for arrow in ui_arrows.values():
		arrow.visible = false
		
func toggle_roll_icon(visibility: bool):
	$RollIcon.visible = visibility

func show_roll_number(number: int):
	$RollNumber/CenterContainer/Number.text = str(number)
	$RollNumber.visible = true
	print('show number', $RollNumber.visible, number)
	
func hide_roll_number():
	$RollNumber.visible = false
