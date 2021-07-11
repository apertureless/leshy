extends Node2D

# First screen with logo etc.
const FIRST_SCREEN = ""
const MENU_SCREEN = "res://Screens/title_screen/TitleScreen.tscn"

var load_state = 0
var current_screen = null

func _ready() -> void:
	Game.main = self
	if Game.debug:
		load_gamestate()
	else: 
		#load_screen(FIRST_SCREEN)
		load_screen(MENU_SCREEN)
		
	var _ret = Gamestate.connect( "gamestate_changed", self, "_on_gamestate_change" )

func load_gamestate() -> void:
	
	match load_state:
		0: 
			# Fade Out
			load_state = 1
			$loadtimer.set_wait_time( 0.2 )
			$loadtimer.start()
		1:
			# Hide Hud etc.
			var children = $levels.get_children()
			if not children.empty():
				children[0].queue_free()
			load_state = 2
			$loadtimer.set_wait_time( 0.05 )
			$loadtimer.start()
		2:
			var new_level = load(Gamestate.state.current_level).instance()
			$levels.add_child(new_level)
			
			# Show hud
			load_state = 3
			$loadtimer.set_wait_time( 0.3 )
			$loadtimer.start()
		3:
			# Fade In Animation
			load_state = 4
			$loadtimer.set_wait_time( 0.3 )
			$loadtimer.start()
		4:
			load_state = 0


func load_screen(screen := "") -> void: 
	if not screen.empty():
		load_state = 0
		current_screen = screen
	
	match load_state:
		0:
			# Fade Out
			load_state = 1
			$screentimer.set_wait_time(0.2)
			$screentimer.start()
		1:
			var children = $levels.get_children()
			if not children.empty():
				children[0].queue_free()
			load_state = 2
			$screentimer.set_wait_time( 0.05 )
			$screentimer.start()
		2:
			var new_level = load(current_screen).instance()
			$levels.add_child(new_level)
			load_state = 3
			$screentimer.set_wait_time( 0.3 )
			$screentimer.start()
		3:
			# Fade In
			load_state = 4
			$screentimer.set_wait_time( 0.3 )
			$screentimer.start()
		4:
			load_state = 0
	

func _on_loadtimer_timeout():
	load_gamestate()
	
func _on_screentimer_timeout() -> void:
	load_screen()


func _on_gamestate_change() -> void:
	pass



