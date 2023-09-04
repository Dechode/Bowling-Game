extends Node3D

var pin_positions: PackedVector3Array
var pins := []
var fallen_pins := []

var ball: BowlingBall = null


func _ready() -> void:
	pin_positions.resize(10)
	var i := 0
	for child in get_children():
		if child is RigidBody3D:
			pin_positions[i] = child.position
			pins.append(child)
			i += 1
	
	GameManager.pins = self


func reset_pins():
	match ball.thrower.throws:
		1:
			fallen_pins.clear()
			var i := 0
			for pin in pins:
				if pin.fallen:
					fallen_pins.append(pin)
					pin.set_active(false)
				
				pin.sleeping = true
				pin.freeze = true
				pin.position = pin_positions[i]
				pin.rotation = Vector3.ZERO
				i += 1
			
			print_debug("%d pins fallen" % fallen_pins.size())
			
			if fallen_pins.size() == 10:
				ball.thrower.score += 30
				GameManager.ui_show_score("Strike!")
				GameManager.frames += 1
				ball.thrower.throws = 0
				for pin in pins:
					pin.set_active(true)
			else:
				ball.thrower.score += fallen_pins.size()
				GameManager.ui_show_score("%d" % fallen_pins.size())
		
		2:
			var i := 0
			var fallen2 := 0
			for pin in pins:
				if pin.fallen:
					if pin not in fallen_pins:
						fallen2 += 1
						fallen_pins.append(pin)
				
				pin.sleeping = true
				pin.freeze = true
				pin.position = pin_positions[i]
				pin.rotation = Vector3.ZERO
				i += 1
				pin.fallen = false
				pin.set_active(true)
			
			print_debug("%d Pins fallen on 2nd throw" % fallen2)
			
			ball.thrower.throws = 0
			ball.thrower.score += fallen2
			
			if fallen_pins.size() == 10:
				GameManager.ui_show_score("Spare!")
			else:
				GameManager.ui_show_score("%d" % fallen2)
				
			fallen_pins.clear()
			GameManager.frames += 1


func _on_reset_timer_timeout() -> void:
	ball.reset()
	reset_pins()
	$ResetTimer.stop()


func _on_pin_area_body_entered(body: Node3D) -> void:
	if body is BowlingBall:
		print_debug("Throw %d" % body.thrower.throws)
		ball = body
		if $ResetTimer.is_stopped():
			$ResetTimer.start()
			ball.timer.stop()
	
		for pin in pins:
			pin.freeze = false
			pin.sleeping = false
