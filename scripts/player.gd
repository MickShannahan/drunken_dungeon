extends CharacterBody2D


const TILE_SIZE: Vector2 = Vector2(16,16)
var sprite_node_pos_tween: Tween
var dice_rolled : int


func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_up") and !$up.is_colliding():
		_move(Vector2(0, -1))
	elif Input.is_action_just_pressed("ui_down") and !$down.is_colliding():
		_move(Vector2(0, 1))
	elif Input.is_action_just_pressed("ui_left") and !$left.is_colliding():
		_move(Vector2(-1, 0))
	elif Input.is_action_just_pressed("ui_right") and !$right.is_colliding():
		_move(Vector2(1, 0))
	elif Input.is_action_just_pressed("ui_accept"):
		_roll_dice()

func _move(dir: Vector2):
	global_position += dir * TILE_SIZE
	
#	required for tweening
	$CharacterSprite.global_position -= dir * TILE_SIZE
	if sprite_node_pos_tween:
			sprite_node_pos_tween.kill()
	sprite_node_pos_tween = create_tween()
	sprite_node_pos_tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	sprite_node_pos_tween.tween_property($CharacterSprite, "global_position", global_position, .15).set_trans(Tween.TRANS_SINE)
	
func _roll_dice():
	var random = RandomNumberGenerator.new()
	dice_rolled = random.randi_range(1,8)
	print_debug('🎲', dice_rolled)
