extends Area2D
class_name Player


const TILE_SIZE: Vector2 = Vector2(16, 16)
var sprite_node_pos_tween: Tween
var dice_rolled: int = 1
var character_name: String = 'slate slabrock'
var is_moving: bool = false
var blood_effect := load("res://scenes/Particles/blood_splatter.tscn")
var blood_drip_effect := load('res://scenes/Particles/blood_drip.tscn')

@export var health: int
@export var attack_power: int
@export var shield: int

@onready var up: RayCast2D = $up
@onready var right: RayCast2D = $right
@onready var down: RayCast2D = $down
@onready var left: RayCast2D = $left
@onready var up_right: RayCast2D = $up_right
@onready var up_left: RayCast2D = $up_left
@onready var down_right: RayCast2D = $down_right
@onready var down_left: RayCast2D = $down_left

signal player_moved_one_unit
signal player_damaged

func move_in_dir(dir: Vector2, dist: int):
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
			
		move_one_unit(Vector2(moving_dir.x, moving_dir.y))
		await resolve_grid_space()
	
	is_moving = false

func recieve_damage(damage: int):
	health = max(0, health - damage)
	player_damaged.emit(health)
	print('🩸', health)
	splatter_blood(damage)
	if health <= 0:
		die()

func move_one_unit(dir: Vector2):
	var target_position = global_position + dir * TILE_SIZE
	if sprite_node_pos_tween:
		sprite_node_pos_tween.kill()
	sprite_node_pos_tween = create_tween()
	sprite_node_pos_tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	sprite_node_pos_tween.tween_property(self, "global_position", target_position, .15).set_trans(Tween.TRANS_SINE)
	await sprite_node_pos_tween.finished
	player_moved_one_unit.emit()
	if health <= 10:
		drip_blood()
	
func resolve_grid_space():
	var enities = get_overlapping_areas()
	print('on top of', enities)
	for entity in enities:
		var stop_resolve = entity.activate(self)
		if stop_resolve: return true
		await get_tree().create_timer(.15).timeout
	await get_tree().create_timer(.05).timeout
		

func _roll_dice():
	var random = RandomNumberGenerator.new()
	dice_rolled = random.randi_range(1, 8)
	print('🎲', dice_rolled)
	
func teleport_player_to_position(position:Vector2):
	global_position = position
	
func splatter_blood(blood_amount:int):
	for b in blood_amount:
		var blood_instance = blood_effect.instantiate()
		get_tree().get_first_node_in_group('Level').add_child(blood_instance)
		blood_instance.global_position = global_position

func drip_blood():
	var blood_instance = blood_drip_effect.instantiate()
	get_tree().get_first_node_in_group('Level').add_child(blood_instance)
	blood_instance.global_position = global_position
	
func die():
	queue_free()
