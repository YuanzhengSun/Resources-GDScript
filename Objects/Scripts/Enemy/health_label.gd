extends Label


func on_health_changed(new_health: float):
	var health_str = "%.2f" % new_health
	
	text = "Health: " + health_str
