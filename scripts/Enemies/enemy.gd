class_name Enemy extends FloorEntity

@export var health_min: int
@export var health_max: int
@export var flipped_h: bool = false
@export var death_effect : PackedScene
var health: int
var is_dead := false
var xp_reward := 1

func _ready():
	entity_activated.connect(battle)
	health = randi_range(health_min, health_max)
	$EnemyUi/Label.text = str(health)
	if flipped_h:
		$EnemySprite.flip_h = true
	
func battle(player: Player):
	print(player.character_name, " hit the ", entity_name)
	player.recieve_damage(health)
	health = max(0, health - player.attack_power)
	if health <=0:
		die()

func recieve_damage(damage:int):
	health = max(0, health - damage)
	if health <=0:
		die()

func die():
	print('💀', self)
	is_dead = true
	$EnemyUi.visible = false
	if death_effect:
		var effect_instance = death_effect.instantiate()
		get_tree().get_first_node_in_group('Level').add_child(effect_instance)
		effect_instance.global_position = global_position
	queue_free()
