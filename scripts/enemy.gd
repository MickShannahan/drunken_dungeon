class_name Enemy extends FloorEntity

@export var health_min: int
@export var health_max: int
var health: int
var is_dead := false
var xp_reward := 1

func _ready():
	entity_activated.connect(battle)
	health = randi_range(health_min, health_max)
	$EnemyUi/Label.text = str(health)
	
func battle(player: Player):
	print(player.character_name, " hit the ", entity_name)
	player.recieve_damage(health)
	health = max(0, health - player.attack_power)
	if health <=0:
		die()
	

func die():
	print('💀', self)
	is_dead = true
	$EnemyUi.visible = false
	queue_free()
