extends Camera2D


@export var target : Player
@export var sensitivity := 0.1


func _physics_process(_delta: float) -> void:
	apply_movement()
	
	offset = CameraShake.get_offset()


func apply_movement():
	var target_position = target.aim_position * sensitivity
	
	position = position.lerp(target_position, 0.25)
