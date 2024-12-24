class_name PlayerHealth
extends Health


@export var invincibility_time := 1.5
@export var collision_shape : CollisionShape2D

@onready var player : Player = get_owner()

var inv_timer : Timer

func _ready():
	super()
	
	inv_timer = Timer.new()
	inv_timer.wait_time = invincibility_time
	inv_timer.timeout.connect(on_inv_timer_timeout)
	add_child(inv_timer)


func on_damaged(attack: Attack) -> void:
	if !player.alive:
		return
	
	super(attack)
	
	if health <= 0:
		player.alive = false
	else:
		inv_timer.start()
		player.invincible = false
		collision_shape.set_deferred("disabled", true)


func on_inv_timer_timeout():
	player.invincible = false
	collision_shape.set_deferred("disabled", false)
