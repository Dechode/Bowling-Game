extends Node

enum GAME_MODE {
	NOT_PLAYING,
	PRACTICE,
	LOCAL_CO_OP,
	AI,
}

var game_mode := GAME_MODE.NOT_PLAYING
var players := []
var ui: UI = null


#func _process(delta: float) -> void:
#	# TODO implement gamemodes
#	match game_mode:
#		GAME_MODE.NOT_PLAYING:
#			pass
#
#		GAME_MODE.PRACTICE:
#			pass
#
#		GAME_MODE.LOCAL_CO_OP:
#			pass
#
#		GAME_MODE.AI:
#			pass


func start_game(mode: GAME_MODE):
	game_mode = mode
	var player := {"name": "Player 1",
					"score": 0,
					"throws": 0,
					}
	
	match mode:
		GAME_MODE.PRACTICE:
			add_player(player)
		
		GAME_MODE.LOCAL_CO_OP:
			var player2 := {"name": "Player 2",
					"score": 0,
					"throws": 0,
					}
			add_player(player)
			add_player(player2)
		
		GAME_MODE.AI:
			var ai := {"name": "AI",
					"score": 0,
					"throws": 0,
					}
			add_player(player)
			add_player(ai)


func add_player(player):
	if players.has(player):
		push_warning("Trying to add duplicate player!")
		return
	
	players.append(player)


func ui_show_score(score):
	ui.show_score(score)

