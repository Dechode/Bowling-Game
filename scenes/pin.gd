class_name BowlingPin
extends RigidBody3D

var fallen := false

@onready var ray := $RayCast3D


func _ready() -> void:
	mass = 1.5


func _process(delta: float) -> void:
	fallen = false
	
	if not ray.is_colliding():
		fallen = true
	else:
#		if ray.get_collider().is_in_group("bowling_lane"):
		if abs(transform.basis.y.dot(Vector3.UP)) < 0.85:
			fallen = true
			
