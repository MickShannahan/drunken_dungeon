extends FloorEntity

@export var damage: int = 3
@export var loaded: bool = false
@export var range: int = 1
@export var projectile: PackedScene

func _ready() -> void:
	entity_activated.connect(step_on_trap)
	GlobalEmitter.connect_to_signal('player_movement_end', fire)
	$Loaded.visible = loaded
	
	collision_layer = 2
	collision_mask = 0

func activate(activating_body: Node2D):
	step_on_trap(activating_body)

func step_on_trap(player: Player):
	loaded = true
	$Loaded.visible = true
	$Trap.visible = false

func fire():
	print('🔥', projectile)
	if loaded and projectile:
		var fired_projectile: Node2D = projectile.instantiate()
		add_child(fired_projectile)
		fired_projectile.global_position = global_position
		var target_pos = $Target.global_position
		var direction = (target_pos - global_position).normalized()
		fired_projectile.rotation = direction.angle()
		
		loaded = false
		$Loaded.visible = false
		$Trap.visible = true
