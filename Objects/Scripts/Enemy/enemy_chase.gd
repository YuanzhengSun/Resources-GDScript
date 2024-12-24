extends Node

@onready var enemy : Enemy = get_owner()

var player : Player
var direction : Vector2

func _ready():
	player = get_tree().get_first_node_in_group("player")


func _physics_process(delta: float) -> void:
	if !enemy.alive:
		return
	
	if !direction || enemy.current_speed >= 0:
		direction = player.global_position - enemy.global_position
	
	var acceleration_step := enemy.stats.max_speed * (1.0 / enemy.acceleration_time) * delta
	
	if enemy.current_speed < 0:
		acceleration_step *= enemy.friction
	
	var target_speed := enemy.stats.max_speed
	
	if !player.alive:
		target_speed = 0
	
	enemy.current_speed = move_toward(enemy.current_speed, target_speed, acceleration_step)
	
	enemy.velocity = direction.normalized()*enemy.current_speed
	enemy.move_and_slide()
