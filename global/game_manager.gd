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
var pins = null
var frames = 0


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
	
	var player := Player.new()
	player.player_name = "Player 1"
	
	match mode:
		GAME_MODE.PRACTICE:
			add_player(player)
		
		GAME_MODE.LOCAL_CO_OP:
			var player2 := Player.new()
			player2.player_name = "Player 2"
			add_player(player)
			add_player(player2)
		
		GAME_MODE.AI:
			var ai := Player.new()
			ai.player_name = "AI"
			add_player(player)
			add_player(ai)


func add_player(player: Player):
	if players.has(player):
		push_warning("Trying to add duplicate player!")
		return
	
	players.append(player)


func ui_show_game_end_screen(score):
	if not ui:
		push_error("No ui set")
		return
	


func ui_show_score(score):
	if not ui:
		push_error("No ui set")
		return
	
	ui.show_score(score)


func advance_frame():
	if frames >= 10:
		print_debug("Game ended")
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
		return
		
	frames += 1

