extends Node2D


@export var projectile_scene : PackedScene = preload("res://Objects/Scenes/bullet.tscn")

@onready var weapon_animation: AnimationPlayer = $WeaponAnimation
@onready var fire_position: Marker2D = $FirePosition

@export var debug_disable := false

func _physics_process(delta: float) -> void:
	if debug_disable:
		return
	
	look_at(get_global_mouse_position())
	
	if Input.is_action_just_pressed("primary_fire"):
		weapon_animation.play("swing")


func fire_projectile():
	var spawned_bullet : Bullet = projectile_scene.instantiate()
	add_child(spawned_bullet)
	spawned_bullet.rotation = (get_global_mouse_position() - global_position).angle()
	spawned_bullet.global_position = fire_position.global_position
	CameraShake.add_trauma(1.0)
