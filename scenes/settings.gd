# SettingsMenu.gd
extends Control

@onready var volume_slider = $HSlider
@onready var display_mode_option_button = $OptionButton

func _ready():
	display_mode_option_button.add_item("Fullscreen")
	display_mode_option_button.add_item("Windowed")
	
	# Set the initial selection based on the current window mode
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
		display_mode_option_button.select(0) # Select Fullscreen
	else:
		display_mode_option_button.select(1) # Select Windowed

	# Connect signals for changes
	display_mode_option_button.item_selected.connect(_on_display_mode_option_button_item_selected)

func _on_display_mode_option_button_item_selected(index):
	# Change display mode based on selection
	if index == 0: # Fullscreen
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	elif index == 1: # Windowed
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)


func _on_h_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(0,value)
