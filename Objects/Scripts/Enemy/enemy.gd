class_name Enemy
extends CharacterBody2D

#########################################################
# I tend to keep the top level node's functionality 
# small. Here, this node is responsible for common state
# variables, passing the damaged signal around, and 
# picking a random texture on spawn.
#
# For the most part, other functionality that controls
# the enemy is handled by specific states.
#
# ex. Movement is handled by states setting velocity
# and calling move_and_slide()
########################################################


signal damaged(attack: Attack)



@export var stats: EnemyStats

var max_speed : float
var variation_range : float
var acceleration_time : float
var friction : float

@onready var sprite : Sprite2D = $Sprite2D
@onready var health: EnemyHealth = $Health

var alive := true
var stunned := false

var current_speed := 0.0

var item_drop : PackedScene = preload("res://Objects/Scenes/item_drop.tscn")


func _ready():
	randomize()
	
	# Distribute stats where they need to be
	health.max_health = stats.max_health
	
	max_speed = stats.max_speed
	variation_range = stats.variation_range
	acceleration_time = stats.acceleration_time
	friction = stats.friction
	
	sprite.texture = stats.texture
	
	max_speed += randf_range(-variation_range, variation_range)


func on_damaged(attack: Attack) -> void:
	damaged.emit(attack)


func on_death() -> void:
	if stats.loot_table:
		for stack: ItemStack in stats.loot_table.roll_loot():
			var spawned_item : ItemDrop = item_drop.instantiate()
			spawned_item.stack = stack
			spawned_item.global_position = global_position
			get_tree().current_scene.add_child.call_deferred(spawned_item)
