extends Node


###################################################
# This controls all animations for the enemy.
# You totally could use an AnimationTree for this,
# but this is an example of how you could control
# it through code.
###################################################


@export var animation_player : AnimationPlayer
@export var sprite : Sprite2D
@onready var enemy : Enemy = get_owner()

var player : Player


func _ready():
	player = get_tree().get_first_node_in_group("player")


func _physics_process(delta: float) -> void:
	if !enemy.alive:
		return
	
	if enemy.stunned:
		animation_player.play("stunned")
		return
	
	if !enemy.velocity:
		animation_player.play("idle")
		return
	
	var direction = player.global_position - enemy.global_position
	sprite.flip_h = direction.x < 0
	
	var animation_name = "walk"
	
	if enemy.velocity.length() > 50:
		animation_name = "run"
	
	
	if sprite.flip_h:
		animation_name += "_left"
	else:
		animation_name += "_right"
	
	animation_player.play(animation_name)
