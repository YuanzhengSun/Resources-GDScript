class_name Health
extends Node

##############################
# Health Component for enemies
##############################

signal health_changed(health: float)
signal max_health_changed(max_health: float)
signal died()

@export var hitbox : Hitbox
@export var animation_player : AnimationPlayer

@export var max_health := 10.0 :
	set(val):
		max_health = val
		max_health_changed.emit(max_health)
		health = max_health
@onready var health := max_health:
	set(val):
		health = val
		health_changed.emit(health)


func _ready():
	if hitbox:
		hitbox.damaged.connect(on_damaged)
	
	max_health_changed.emit(max_health)
	health_changed.emit(health)


func on_damaged(attack: Attack):
	health -= attack.damage
	health = max(0, health)
	
	if health <= 0:
		if animation_player:
			animation_player.play("death")
