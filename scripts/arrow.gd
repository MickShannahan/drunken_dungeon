extends Area2D

@export var speed: float = 200.0
@export var damage: int = 3

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	area_entered.connect(_on_area_entered)
	print('arrow fired')

func _physics_process(delta: float) -> void:
	global_position += Vector2.from_angle(rotation) * speed * delta

func _on_body_entered(body: Node2D) -> void:
	_on_collision(body)

func _on_area_entered(area: Area2D) -> void:
		_on_collision(area)

func _on_collision(colliding_body: Node):
	print('💥', colliding_body)
	if colliding_body is Player:
		print('🎯hit player')
		colliding_body.recieve_damage(damage)
		queue_free()
	elif colliding_body.has_method('recieve_damage'):
		colliding_body.recieve_damage(damage)
		queue_free()
	elif colliding_body is TileMapLayer or colliding_body is TileMap:
		speed = 0
		collision_layer = 0
		collision_mask = 0
