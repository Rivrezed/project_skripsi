extends CharacterBody2D

@export var walk_speed = 150.0
@export var run_speed = 250.0
@export_range(0, 1) var acceleration = 0.1
@export_range(0, 1) var deceleration = 0.1

@export var jump_force = -400.0
@export_range(0, 1) var decelerate_on_jump_release = 0.5

@export var animated_sprite : AnimatedSprite2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	# Tambahkan gravitasi
	if not is_on_floor():
		velocity.y += gravity * delta

	var speed
	if Input.is_action_pressed("run"):
		speed = run_speed
	else:
		speed = walk_speed

	# Ambil arah input dan atur kecepatan horizontal
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = move_toward(velocity.x, direction * speed, speed * acceleration)
		animated_sprite.flip_h = direction == -1
		if is_on_floor():
			if Input.is_action_pressed("run"):
				animated_sprite.play("run")
			#walk state
			else:
				animated_sprite.play("run")
	else:
		velocity.x = move_toward(velocity.x, 0, walk_speed * deceleration)
		if is_on_floor():
			animated_sprite.play("idle")

	# Lompat
	if Input.is_action_just_pressed("jump") and (is_on_floor() or is_on_wall()):
		velocity.y = jump_force
		animated_sprite.play("jump")

	if Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y *= decelerate_on_jump_release

	move_and_slide()
