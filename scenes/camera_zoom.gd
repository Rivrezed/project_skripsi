extends Camera2D

const MIN_ZOOM = Vector2(1.0, 1.0)
const MAX_ZOOM = Vector2(2.0, 2.0)
const ZOOM_STEP = 0.5
const ZOOM_SPEED = 15  # Semakin besar, semakin cepat transisinya

var target_zoom: Vector2

func _ready():
	target_zoom = zoom

func _unhandled_input(event):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			_zoom_out()
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			_zoom_in()

func _process(delta):
	zoom = zoom.lerp(target_zoom, delta * ZOOM_SPEED)

func _zoom_in():
	target_zoom -= Vector2(ZOOM_STEP, ZOOM_STEP)
	target_zoom.x = clamp(target_zoom.x, MIN_ZOOM.x, MAX_ZOOM.x)
	target_zoom.y = clamp(target_zoom.y, MIN_ZOOM.y, MAX_ZOOM.y)

func _zoom_out():
	target_zoom += Vector2(ZOOM_STEP, ZOOM_STEP)
	target_zoom.x = clamp(target_zoom.x, MIN_ZOOM.x, MAX_ZOOM.x)
	target_zoom.y = clamp(target_zoom.y, MIN_ZOOM.y, MAX_ZOOM.y)
