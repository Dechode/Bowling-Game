class_name BowlingPin
extends RigidBody3D

@export var hit_sound_paths := []

var fallen := false
var active := true
var prev_pos := Vector3.ZERO
var delta_vel := 0.0

var sound_streams := []

@onready var ray := $RayCast3D


func _ready() -> void:
	mass = 1.5
	
	sound_streams.resize(hit_sound_paths.size())
	
	var i := 0
	for path in hit_sound_paths:
		sound_streams[i] = load(path)
		i += 1


func _process(delta: float) -> void:
	if active:
		fallen = false
		
		if not ray.is_colliding():
			fallen = true
		else:
			if abs(transform.basis.y.dot(Vector3.UP)) < 0.85:
				fallen = true


func _physics_process(delta: float) -> void:
	delta_vel = position.distance_to(prev_pos)
	prev_pos = position


func _on_body_entered(body: Node) -> void:
	if delta_vel > 0.01 and not $AudioStreamPlayer.playing:
#		print_debug("Pin hit!")
		$AudioStreamPlayer.stream = sound_streams.pick_random()
		$AudioStreamPlayer.volume_db = linear_to_db(clampf(delta_vel / 0.2, 0.1, 1.0))
		$AudioStreamPlayer.play()


func set_active(p_active):
	active = p_active
	visible = p_active
#	freeze = not p_active
#	sleeping = not p_active
#	fallen = false
	$CollisionShape3D.disabled = not p_active
