extends StaticBody2D

@onready var red_light: Sprite2D = $RedLight
@onready var yellow_light: Sprite2D = $YellowLight
@onready var green_light: Sprite2D = $GreenLight
@onready var finite_state_machine: FiniteStateMachine = $FiniteStateMachine

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	red_light.turn_off()
	yellow_light.turn_off()
	green_light.turn_off()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_timer_timeout() -> void:
	finite_state_machine.move_sequence()


func _on_change_state(new_state) -> void:
	match new_state:
		FiniteStateMachine.action_state.RED:
			yellow_light.turn_off()
			green_light.turn_off()
			red_light.turn_on()
		FiniteStateMachine.action_state.GREEN:
			red_light.turn_off()
			yellow_light.turn_off()
			green_light.turn_on()
			
		FiniteStateMachine.action_state.YELLOW:
			red_light.turn_off()
			yellow_light.turn_on()
			green_light.turn_off()
			
		FiniteStateMachine.action_state.OFF:
			red_light.turn_off()
			yellow_light.turn_off()
			green_light.turn_off()


func _on_button_pressed() -> void:
	finite_state_machine.move_sequence()


func _on_button_2_pressed() -> void:
	finite_state_machine.stop_sequence()
