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
	$FrameLabel.text = "Frame: %d" % [GameManager.frames]


func show_score(score: String):
	$ScorePopUp.text = score
	$ScorePopUp.show()
	$ScorePopUp/Timer.start()


func _on_score_popup_timer_timeout() -> void:
	$ScorePopUp.hide()
