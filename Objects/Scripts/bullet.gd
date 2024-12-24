class_name Bullet
extends CharacterBody2D

@export var hurtbox : Hurtbox

var speed := 200.0
var damage := 5.0
var max_pierce := 1
var knockback_force := 1.0

@export var dampening : float = 50.0
@export var dampening_ratio : float = 0.05

@export var lifetime : float = 1.0
var current_lifetime := 0.0

var current_pierce_count := 0

@onready var sprite: Sprite2D = $Sprite2D


func _ready():
	if hurtbox:
		hurtbox.hit_enemy.connect(on_enemy_hit)


func _process(delta: float) -> void:
	current_lifetime += delta
	
	if current_lifetime >= lifetime:
		queue_free()
	
	var lifetime_ratio = (current_lifetime / lifetime)
	
	sprite.modulate.a = 1 - lifetime_ratio**3
	


func _physics_process(delta: float) -> void:
	var direction = Vector2.RIGHT.rotated(rotation)
	
	var flat_dampen = dampening*delta
	var scaled_dampen = dampening_ratio * speed
	
	if flat_dampen > scaled_dampen:
		scaled_dampen = flat_dampen
	
	speed = move_toward(speed, 0, scaled_dampen)
	velocity = direction*speed
	
	var collision := move_and_collide(velocity*delta)
	
	if collision:
		queue_free()
	
	if speed <= 0:
		queue_free()


func on_enemy_hit():
	current_pierce_count += 1
	HitPause.slow_down_timer(0.75, 0.05)
	
	if current_pierce_count >= max_pierce:
		queue_free()
