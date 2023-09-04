class_name BowlingBall
extends RigidBody3D

var launched := false
var throw_multiplier := 0.0
var throwing_force := Vector3.ZERO

var init_pos := Vector3.ZERO
var thrower := {}

@onready var timer := $Timer


func _ready() -> void:
	freeze = true
	init_pos = position
	thrower = GameManager.players[0]


func _physics_process(delta: float) -> void:
	if launched:
		if get_contact_count() <= 0:
			$AudioStreamPlayer3D.stop()
			return
		else:
			play_rolling_sound(linear_velocity.length())
		
		return
	
	var rot_speed := 0.05
	var move_speed := 1.0
	var max_throw_force := 80.0
	
	if Input.is_action_pressed("turn_left"):
		rotation.y += rot_speed * delta
	if Input.is_action_pressed("turn_right"):
		rotation.y += -rot_speed * delta
	
	if Input.is_action_pressed("move_left"):
		transform.origin += transform.basis.x * Vector3.LEFT * move_speed * delta
	if Input.is_action_pressed("move_right"):
		transform.origin += transform.basis.x * Vector3.RIGHT * move_speed * delta
	
	if Input.is_action_pressed("launch"):
		throw_multiplier += 1.0 * delta
		throw_multiplier = clamp(throw_multiplier, 0.0, 1.0)
	
	if Input.is_action_just_released("launch") and not launched:
		throwing_force = -transform.basis.z * max_throw_force * throw_multiplier
		throwing_force.y = 0.25 * abs(throwing_force.z)
		
		launched = true
		freeze = false
		$ArrowMesh.visible = false
		apply_central_impulse(throwing_force)
		timer.start()
		thrower.throws += 1


func reset():
	freeze = true
	position = init_pos
	launched = false
	throw_multiplier = 0.0
	rotation = Vector3.ZERO
	$ArrowMesh.visible = true
	timer.stop()
	$AudioStreamPlayer3D.stop()


func _on_timer_timeout() -> void:
	reset()
	GameManager.pins.reset_pins()


func play_rolling_sound(speed):
	if linear_velocity.length() < 1.0:
		$AudioStreamPlayer3D.stop()
		return
	
	var mult := clampf(speed / 12.0, 0.01, 1.0)
	var volume := linear_to_db(mult)
	$AudioStreamPlayer3D.volume_db = volume
	$AudioStreamPlayer3D.pitch_scale = clampf(mult, 0.75, 1.0)
	
	if not $AudioStreamPlayer3D.playing:
		$AudioStreamPlayer3D.play()
	
