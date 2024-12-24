extends Node


## Curve that represents how much the unit should be affected by knockback when
## the player gets hit
@export var distance_curve : Curve
## Scale of distance curve, 1 in distance curve is equal to this many units
@export var distance_range := 50.0
@export var player_knockback_power := 50.0

@onready var enemy : Enemy = get_owner()

var player : Player

func _ready():
	player = get_tree().get_first_node_in_group("player")
	
	enemy.damaged.connect(on_damaged)
	player.damaged.connect(on_player_damaged)


func on_damaged(attack: Attack):
	enemy.current_speed -= attack.knockback


func on_player_damaged(_attack: Attack):
	var distance = enemy.global_position.distance_to(player.global_position)
	
	var impact_scale = distance_curve.sample(distance / distance_range)
	var scaled_knockback = -player_knockback_power*impact_scale
	
	if abs(scaled_knockback) > 0:
		enemy.current_speed = scaled_knockback
