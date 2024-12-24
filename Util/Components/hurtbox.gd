class_name Hurtbox
extends Area2D

signal hit_enemy


var bullet : Bullet


func _ready() -> void:
	if owner is Bullet:
		bullet = owner
	
	area_entered.connect(on_area_entered)


func on_area_entered(area: Area2D):
	var valid := true
	if bullet && bullet.is_queued_for_deletion():
		valid = false
	
	if area is Hitbox && valid:
		var attack := Attack.new()
		
		if bullet:
			attack.damage = bullet.damage
			attack.knockback = bullet.knockback_force
		else:
			attack.damage = 1
		
		area.damage(attack)
		
		hit_enemy.emit()
