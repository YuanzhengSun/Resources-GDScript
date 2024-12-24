extends Area2D

@export var next_level : PackedScene

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready():
	body_entered.connect(on_player_entered)


func on_player_entered(body: CharacterBody2D):
	if body is Player:
		animation_player.play("fade_out")


func switch_to_level():
	get_tree().change_scene_to_packed(next_level)
