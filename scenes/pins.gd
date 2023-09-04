extends Node3D

var pin_positions: PackedVector3Array
var pins := []

var ball: BowlingBall = null


func _ready() -> void:
	pin_positions.resize(10)
	var i := 0
	for child in get_children():
		if child is RigidBody3D:
			pin_positions[i] = child.position
			pins.append(child)
			i += 1


func reset_pins():
	var i := 0
	var fallen_count := 0
	for pin in pins:
		if pin.fallen:
			fallen_count += 1
		
		pin.freeze = true
		pin.sleeping = true
		pin.position = pin_positions[i]
		pin.rotation = Vector3.ZERO
		i += 1
	
	print_debug("%d pins fallen" % fallen_count)
	
	if fallen_count == 10:
		ball.thrower.score += 30
		GameManager.ui_show_strike_screen()
	else:
		ball.thrower.score += fallen_count


func _on_reset_timer_timeout() -> void:
	reset_pins()
	ball.reset()
	$ResetTimer.stop()


func _on_pin_area_body_entered(body: Node3D) -> void:
	if body is BowlingBall:
		ball = body
		if $ResetTimer.is_stopped():
			$ResetTimer.start()
			ball.timer.stop()
	
		for pin in pins:
			pin.freeze = false
			pin.sleeping = false
