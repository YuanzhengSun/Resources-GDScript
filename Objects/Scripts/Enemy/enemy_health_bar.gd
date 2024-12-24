extends ProgressBar

var max_health := 0.0


func on_health_changed(new_health):
	value = new_health / max_health


func on_max_health_changed(new_max_health: float):
	self.max_health = new_max_health
