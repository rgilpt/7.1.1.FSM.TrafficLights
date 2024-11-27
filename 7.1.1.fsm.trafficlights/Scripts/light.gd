extends Sprite2D

@export_color_no_alpha var light_off:Color
@export_color_no_alpha var light_on:Color

func turn_on():
	modulate = light_on

func turn_off():
	modulate = light_off
	
