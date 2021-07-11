extends Level

func _ready() -> void:
	var t = Timer.new()
	t.wait_time = 0.5
	t.one_shot = true
	t.connect("timeout", self, "_connect_areas")
	add_child(t)
	t.start()
	
func _connect_areas() -> void:
	pass
	
