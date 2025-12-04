extends CharacterBody2D


const TILE_SIZE: Vector2 = Vector2(16, 16)
var sprite_node_pos_tween: Tween
var dice_rolled: int = 1
var character_name: String = 'slate slabrock'
var is_moving: bool = false


func _physics_process(delta: float) -> void:
	_handle_input()


func _handle_input():
	if is_moving: return

	if Input.is_action_just_pressed("ui_accept"): # 🎲 dice roll
		_roll_dice()

	elif dice_rolled % 2 == 0: # even dice roll
		if Input.is_action_just_pressed("ui_up"):
			_move_in_dir(Vector2(0, -1), dice_rolled)
		elif Input.is_action_just_pressed("ui_down"):
			_move_in_dir(Vector2(0, 1), dice_rolled)
		elif Input.is_action_just_pressed("ui_left"):
			_move_in_dir(Vector2(-1, 0), dice_rolled)
		elif Input.is_action_just_pressed("ui_right"):
			_move_in_dir(Vector2(1, 0), dice_rolled)

	elif dice_rolled % 2 != 0: # odd dice roll
		if Input.is_action_just_pressed("ui_up") and Input.is_action_just_pressed("ui_right"): # ↗️
			_move_in_dir(Vector2(1, -1), dice_rolled)
		elif Input.is_action_just_pressed("ui_up") and Input.is_action_just_pressed("ui_left"): # ↖️
			_move_in_dir(Vector2(-1, -1), dice_rolled)
		elif Input.is_action_just_pressed("ui_down") and Input.is_action_just_pressed("ui_right"): # ↘️
			_move_in_dir(Vector2(1, 1), dice_rolled)
		elif Input.is_action_just_pressed("ui_down") and Input.is_action_just_pressed("ui_left"): # ↙️
			_move_in_dir(Vector2(-1, 1), dice_rolled)
			

func _move_in_dir(dir: Vector2, dist: int):
	is_moving = true
	var moving_dir = dir
	for i in dist:
		# Handle cardinal directions first - these are the primary bounces
		if $up.is_colliding() and moving_dir.y < 0:
			moving_dir.y = 1
		if $down.is_colliding() and moving_dir.y > 0:
			moving_dir.y = -1
		if $right.is_colliding() and moving_dir.x > 0:
			moving_dir.x = -1
		if $left.is_colliding() and moving_dir.x < 0:
			moving_dir.x = 1
		
		# Then check diagonals only if they would block the NEW direction
		if $up_left.is_colliding() and moving_dir.x < 0 and moving_dir.y < 0:
			moving_dir.y = 1
			moving_dir.x = 1
		if $up_right.is_colliding() and moving_dir.x > 0 and moving_dir.y < 0:
			moving_dir.y = 1
			moving_dir.x = -1
		if $down_left.is_colliding() and moving_dir.x < 0 and moving_dir.y > 0:
			moving_dir.y = -1
			moving_dir.x = 1
		if $down_right.is_colliding() and moving_dir.x > 0 and moving_dir.y > 0:
			moving_dir.y = -1
			moving_dir.x = -1
			
		_move_one_unit(Vector2(moving_dir.x, moving_dir.y))
		await _resolve_grid_space()
	
	is_moving = false
		
func _move_one_unit(dir: Vector2):
	global_position += dir * TILE_SIZE
	
#	required for tweening
	$CharacterSprite.global_position -= dir * TILE_SIZE
	if sprite_node_pos_tween:
			sprite_node_pos_tween.kill()
	sprite_node_pos_tween = create_tween()
	sprite_node_pos_tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	sprite_node_pos_tween.tween_property($CharacterSprite, "global_position", global_position, .15).set_trans(Tween.TRANS_SINE)
	
func _resolve_grid_space():
	await get_tree().create_timer(.25).timeout
	

func _roll_dice():
	var random = RandomNumberGenerator.new()
	dice_rolled = random.randi_range(1, 8)
	print_debug('🎲', dice_rolled)
