class_name EnemyHealth
extends Health

@onready var enemy : Enemy = get_owner()

func _ready():
	health = max_health
	super()


func on_damaged(attack: Attack) -> void:
	if !enemy.alive:
		return
	
	super(attack)
	
	if health <= 0:
		died.emit()
		enemy.alive = false
