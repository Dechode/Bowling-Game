class_name UI
extends Control

var ball: BowlingBall = null

func _ready() -> void:
	for sibling in get_parent().get_children():
		if sibling is BowlingBall:
			ball = sibling
	
	GameManager.ui = self


func _process(delta: float) -> void:
	$ProgressBar.value = ball.throw_multiplier * 100.0
	$Score.text = "Score: %d" % ball.thrower.score


func show_strike():
	$StrikeText.show()
	$StrikeText/Timer.start()


func show_spare():
	$SpareText.show()
	$SpareText/Timer.start()


func _on_strike_text_timer_timeout() -> void:
	$StrikeText.hide()


func _on_spare_text_timer_timeout() -> void:
	$SpareText.hide()
