extends Node


var active_timers := []

# Mapped by [Node, float]
var current_slow_sources : Dictionary = {}


func add_slow_down(amount: float, source: Node) -> void:
	current_slow_sources[source] = amount
	
	calc_slowdown()


func remove_slow_down(source: Node) -> void:
	current_slow_sources.erase(source)
	
	calc_slowdown()


func slow_down_timer(amount: float, time: float = -1):
	var timer = SlowdownTimer.new(time, amount)
	timer.timeout.connect(on_slowdown_timeout)
	
	active_timers.append(timer)
	
	calc_slowdown()


func _process(delta: float) -> void:
	for timer in active_timers:
		timer.tick(delta)
	
	calc_slowdown()


func calc_slowdown():
	var total := 1.0
	
	for timer in active_timers:
		total *= timer.amount
	
	for source: Node in current_slow_sources.keys():
		if source && is_instance_valid(source):
			total *= current_slow_sources[source]
		else:
			current_slow_sources.erase(source)
	
	Engine.time_scale = total


func on_slowdown_timeout(timer: SlowdownTimer):
	Engine.time_scale += timer.amount
	active_timers.erase(timer)


class SlowdownTimer:
	
	signal timeout(timer: SlowdownTimer)
	
	var time : float
	var current_time : float
	
	var amount : float
	
	
	func _init(t: float, a: float):
		self.time = t
		self.amount = a
	
	
	func tick(delta: float):
		current_time += (delta / Engine.time_scale)
		
		if current_time >= time:
			timeout.emit(self)
