extends Camera3D

const SPEED := 1.5

@export var ball: RigidBody3D

var init_pos := Vector3.ZERO
var prev_pos := Vector3.ZERO


func _ready() -> void:
	init_pos = position


func _physics_process(delta: float) -> void:
	var ball_pos := ball.transform.origin
	
	if not ball.launched:
		transform.origin = ball_pos
		transform.origin.z += 1.0
		transform.origin.y += 0.5
		look_at(ball_pos)
		return
	
	var weight := delta * SPEED
	var target_pos := ball_pos
	
	transform.origin = lerp(transform.origin, target_pos, weight)
	if transform.origin.distance_to(init_pos) > 18:
		transform.origin = prev_pos
	transform.origin.y = 0.75
	
	var look_at_pos = ball_pos
	look_at_pos.y = 0.25
	look_at(look_at_pos)
	
	prev_pos = position
