@tool
extends HBoxContainer

@export var refresh : bool


func _process(_delta: float) -> void:
	if Engine.is_editor_hint() && refresh:
		size.x = 0
		position.x = size.x / -2
		refresh = false
