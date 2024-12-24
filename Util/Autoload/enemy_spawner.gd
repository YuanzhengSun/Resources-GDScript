extends Node2D

################################################
# This is an autoloaded node that allows you
# to spawn an enemy when pressing "E" by default
# or num keys for specific dinos
################################################


var enemy_scene : PackedScene = preload("res://Objects/Scenes/enemy.tscn")

var enemy_stats: Array[EnemyStats] = [
	preload("res://Resources/Enemy/yellow_dino.tres"),
	preload("res://Resources/Enemy/red_dino.tres"),
	preload("res://Resources/Enemy/blue_dino.tres"),
	preload("res://Resources/Enemy/green_dino.tres"),
]


func _physics_process(delta: float) -> void:
	for i in enemy_stats.size():
		if Input.is_action_just_pressed("spawn_" + str(i+1)):
			spawn_enemy(enemy_stats[i])
		
	
	if Input.is_action_just_pressed("spawn_enemy"):
		spawn_enemy(enemy_stats.pick_random())


func spawn_enemy(stats: EnemyStats):
	var spawned_enemy : Enemy = enemy_scene.instantiate()
	spawned_enemy.stats = stats
	get_tree().root.add_child(spawned_enemy)
	spawned_enemy.global_position = get_global_mouse_position()
