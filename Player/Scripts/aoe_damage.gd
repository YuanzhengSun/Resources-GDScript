extends Node2D


@export var area_radius := 25.0
@export var attack_damage := 0.1
@export var cooldown_time := 0.1
@export var knockback_value := 0.0

@onready var proc_timer: Timer = $ProcTimer
@onready var effect_area: Area2D = $EffectArea
@onready var effect_shape: CollisionShape2D = $EffectArea/CollisionShape2D


func _ready() -> void:
	proc_timer.wait_time = cooldown_time
	proc_timer.timeout.connect(on_proc_timer)
	
	var circle_shape = effect_shape.shape as CircleShape2D
	
	circle_shape.radius = area_radius


func on_proc_timer():
	var areas := effect_area.get_overlapping_areas()
	
	var attack := Attack.new()
	attack.damage = attack_damage
	attack.knockback = knockback_value
	
	for area in areas:
		if area is Hitbox:
			area.damage(attack)
