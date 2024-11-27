
class_name FiniteStateMachine
extends Node

@export var verbose_level = 1

var current_state = null

#var long_decision_timer: Timer
#var short_decision_timer: Timer
@onready var timer: Timer = $Timer

@export var actor: PhysicsBody2D = null
enum action_state{
	OFF,
	RED,
	GREEN,
	YELLOW
}

enum state_result_type{
	failed,
	success,
	started,
	working,
}

var sequence = [	
					{"action": action_state.RED},
					{"current_state": action_state.RED, "post_action":{"timer": 5.0}},
					{"action": action_state.GREEN},
					{"current_state": action_state.GREEN, "post_action":{"timer": 5.0}},
					{"action": action_state.YELLOW},
					{"current_state": action_state.YELLOW, "post_action":{"timer": 2.0}},
					{"restart": true},
				]
				
var  current_index_sequence = -1
var sequence_is_running = false

var state_result = state_result_type.started
signal change_state_result(result_value)
signal change_state(new_state)

var overide_next_action = null


func _ready():
	current_state = action_state.OFF
	
	if actor != null:
		#self.connect("change_state_result", actor._on_state_result_changed)
		self.connect("change_state", actor._on_change_state)


func move_sequence():
	sequence_is_running = true
	current_index_sequence += 1
	if sequence[current_index_sequence].has("action"):
		set_state(sequence[current_index_sequence]["action"])
	elif sequence[current_index_sequence].has("restart"):
		current_index_sequence = 0
		set_state(sequence[current_index_sequence]["action"])
		
func stop_sequence():
	timer.stop()
	sequence_is_running = false
	current_index_sequence = -1
	set_state(action_state.OFF)
func get_pretty_current_state():
	return current_state.name_state

func _physics_process(delta):
	
	if current_state != null:
		pass
		#if current_state.has_method("action_state"):
			#current_state.action_state()

func long_decision():

	pass

func short_decision():
	
	pass

func small_deviation(my_vector:Vector2):
	return my_vector.rotated(randf_range(PI/6, PI/6*3))
func set_state(new_state):
	if overide_next_action != null:
		new_state = overide_next_action
		overide_next_action = null
	if sequence_is_running:
		match new_state:
			action_state.RED:
				current_index_sequence += 1
			action_state.YELLOW:
				current_index_sequence += 1
			action_state.GREEN:
				current_index_sequence += 1
			action_state.OFF:
				new_state = action_state.RED
				current_index_sequence = -1
		if sequence[current_index_sequence].has("post_action"):
			timer.wait_time = sequence[current_index_sequence]["post_action"]["timer"]
			timer.start()
		
	current_state = new_state
	change_state_result.emit(state_result_type.success)
	change_state.emit(current_state)
	set_state_result(state_result_type.started)
	#change_state_result.emit(state_result_type.started)
	if verbose_level > 0:
		print("New State")
	return current_state
	
func set_state_result(result_type):
	state_result = result_type
	change_state_result.emit(result_type)
