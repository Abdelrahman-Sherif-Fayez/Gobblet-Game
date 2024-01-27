extends Control

@onready var tile_scene = preload("res://tile.tscn")
@onready var board_grid = $GobbletBoard/BoardGrid
@onready var piece_scene = preload("res://piece.tscn")
@onready var gobblet_board = $GobbletBoard
@onready var bitboard = $Bitboard
@onready var generate_path = $GeneratePath
@onready var bot_1 = $Bot
@onready var bot_2 = $Bot

# For Labels and Buttons
@onready var main = $".."
@onready var game_status_label = $"../GameStatus"
@onready var player_turn_label = $"../PlayerTurn"
@onready var select_game_mode_label = $"../SelectGameMode"
@onready var select_game_mode_hvh_button = $"../SelectGameMode/HvH"
@onready var select_game_mode_hvai_button = $"../SelectGameMode/HvAI"
@onready var select_game_mode_aivai_button = $"../SelectGameMode/AIvAI"
@onready var select_ai_1_diff_label = $"../SelectAIOne"
@onready var select_ai_2_diff_label = $"../SelectAITwo"
@onready var select_ai_1_easy_button = $"../SelectAIOne/EASY"
@onready var select_ai_1_hard_button = $"../SelectAIOne/HARD"
@onready var select_ai_2_easy_button = $"../SelectAITwo/EASY"
@onready var select_ai_2_hard_button = $"../SelectAITwo/HARD"

var grid_array := []
var black_pieces_array := [[], [], []]
var white_pieces_array := [[], [], []]
var piece_array := [[], [], [], [],[], [], [], [], [], [], [], [], [], [], [], []] # Array that contains the top piece of each of the 16 tiles
var piece_selected = null
var game_bitboard # the current bitboard of the game
var gamestarted = null
var bot_1_difficulty = 1 # bot 1 depth and is by default equal 1 if not changed
var bot_2_difficulty = 1  # bot 2 depth and is by default equal 1 if not changed
var game_mode = 1 # can take 1 or 2 or 3 to represent HvsH, HvsAI, AIvsAI and default is HvsH

func _process(_delta):
	pass

func create_tiles():
	var x_off = 0
	var y_off = 0
	for i in range(4):
		x_off = 0
		y_off = (i*162)
		for j in range(4):
			x_off = (j*162)
			var position_off = Vector2(x_off, y_off)
			create_tile(position_off)

func create_tile(pos_vector):
	var new_tile = tile_scene.instantiate()
	new_tile.tile_ID = grid_array.size()
	new_tile.position += pos_vector
	board_grid.add_child(new_tile)
	grid_array.push_back(new_tile)
	if game_mode != 3:
		new_tile.tile_clicked.connect(_on_tile_clicked)

# A function to handle the cases when a tile is selected
func _on_tile_clicked(tile) -> void:
	if not piece_selected:
		return
	if tile.state != DataHandler.tile_states.FREE:
		return
	move_piece(piece_selected, tile.tile_ID)
	clear_board_filter()
	piece_selected = null
	if gamestarted and game_mode == 2:
		var move = bot_1.play_best_move(true,bot_1_difficulty) # pass whose player turn and depth to play_best_move 
		print(move.from_)
		print(move.to)
		print(move.size)
		print(move.isblack)
		update_board(move)

func update_board(move):
	var piece_to_move
	if move.size ==0:#small
		move.size = 25*25
	elif move.size ==1: #medium
		move.size = 50*50
	elif move.size ==2: #large
		move.size = 75*75
	elif move.size ==3: #XL
		move.size = 100*100

	if move.from_ == -1:
		if move.isblack:
			for i in range(3):
				#print(black_pieces_array[i][0].get_size_number())
				if len(black_pieces_array[i]) != 0:
					if(black_pieces_array[i][0].get_size_number() * black_pieces_array[i][0].get_size_number() == move.size):
						piece_to_move = black_pieces_array[i].pop_front()
						break;
		else:
			for i in range(3):
				#print(move.size)
				#print(white_pieces_array[i][0].get_size())
				if len(white_pieces_array[i]) != 0 :
					if(white_pieces_array[i][0].get_size_number() * white_pieces_array[i][0].get_size_number() == move.size):
						piece_to_move = white_pieces_array[i].pop_front()
						break;
	else:
		piece_to_move = piece_array[move.from_].pop_front()
		remove_piece_from_bitboard(piece_to_move)
	
	var tween = get_tree().create_tween()
	print(piece_to_move)
	var icon_offset = piece_to_move.get_size()
	icon_offset.x = icon_offset.x / 2
	icon_offset.y = icon_offset.y /  2
	tween.tween_property(piece_to_move, "global_position", grid_array[move.to].global_position - icon_offset, 0.5)
	piece_array[move.to].push_front(piece_to_move)
	piece_to_move.tile_ID = move.to
	bitboard.add_piece(move.to, piece_to_move.type)
	self.move_child(piece_to_move, -1)
	#print(bitboard)
	#Check if some color has won
	var winningColor = bitboard.has_won()
	if winningColor == "Black wins" || winningColor == "White wins":
		main.show_finish_message(winningColor)
		gamestarted = false
		return
	main.alternate_turn()

# A function to move the selected piece to the clicked tile
func move_piece(piece, location)-> void:  #location is an index 
	#condition if new piece moved from outside into the board
	if piece.tile_ID == -1:
		piece_array[location].push_front(piece)
		#print(piece_array[location])
	else:
		piece_array[piece.tile_ID].pop_front()
		piece_array[location].push_front(piece)
	remove_piece_from_bitboard(piece)
	piece.tile_ID = location
	self.move_child(piece, -1)
	var tween = get_tree().create_tween()
	var icon_offset = piece.get_size()
	icon_offset.x = icon_offset.x / 2
	icon_offset.y = icon_offset.y /  2
	tween.tween_property(piece, "global_position", grid_array[location].global_position - icon_offset, 0.5)
	bitboard.add_piece(location, piece.type)
	#Check if some color has won
	var winningColor = bitboard.has_won()
	if winningColor == "Black wins" || winningColor == "White wins":
		main.show_finish_message(winningColor)
		gamestarted = false
		return
	main.alternate_turn()

func remove_piece_from_bitboard(piece):
	bitboard.remove_piece(piece.tile_ID, piece.type)

func add_piece(piece_type, location, is_black, stack_no) -> void: #location is an index 
	var new_piece = piece_scene.instantiate()
	self.add_child(new_piece)
	if is_black:
		black_pieces_array[stack_no].push_front(new_piece)
	else:
		white_pieces_array[stack_no].push_front(new_piece)
	new_piece.type = piece_type
	new_piece.tile_ID = -1
	new_piece.load_icon(piece_type)
	#var icon_offset = new_piece.get_size()
	#icon_offset.x = icon_offset.x / 2
	#icon_offset.y = icon_offset.y /  2
	new_piece.global_position = location
	#piece_array[location] = new_piece
	if game_mode != 3:
		new_piece.piece_selected.connect(_on_piece_selected)

func _on_piece_selected(piece):
	if gamestarted:
		if piece_selected:
			_on_tile_clicked(grid_array[piece.tile_ID])
		else:
			var moves
			var bitboard_value_for_filter = 0
			game_bitboard = bitboard.get_board()
			if (player_turn_label.text == "White Turn" && piece.type < 4) || (player_turn_label.text == "Black Turn" && piece.type >=4):
				return
			else:
				piece_selected = piece
				piece_selected.global_position = Vector2(piece_selected.position.x+45, piece_selected.position.y-45)
				if piece.get_size_number() == 100:
					if piece.type < 4:
						if piece.tile_ID == -1:
							moves = generate_path.get_external_moves(game_bitboard.white_pieces, game_bitboard.black_pieces, 1)
							moves = filter_moves(moves, piece)
						else:
							moves = generate_path.get_XL_moves(game_bitboard.white_pieces, game_bitboard.black_pieces, 1)
						for m in moves:
							bitboard_value_for_filter |=  1 << m.to
						set_board_filter(bitboard_value_for_filter)
						# Check if the piece cannot be moved the opponent wins
						check_if_lost(moves, 1)
					else:
						if piece.tile_ID == -1:
							moves = generate_path.get_external_moves(game_bitboard.white_pieces, game_bitboard.black_pieces, 0)
							moves = filter_moves(moves, piece)
						else:
							moves = generate_path.get_XL_moves(game_bitboard.white_pieces, game_bitboard.black_pieces, 0)
						for m in moves:
							bitboard_value_for_filter |= 1 << m.to
						set_board_filter(bitboard_value_for_filter)
						# Check if the piece cannot be moved
						check_if_lost(moves, 0)
				else: if piece.get_size_number() == 75:
					if piece.type < 4:
						if piece.tile_ID == -1:
							moves = generate_path.get_external_moves(game_bitboard.white_pieces, game_bitboard.black_pieces, 1)
							moves = filter_moves(moves, piece)
						else:
							moves = generate_path.get_L_moves(game_bitboard.white_pieces, game_bitboard.black_pieces, 1)
						for m in moves:
							bitboard_value_for_filter |= 1 << m.to
						set_board_filter(bitboard_value_for_filter)
						# Check if the piece cannot be moved
						check_if_lost(moves, 1)
					else:
						if piece.tile_ID == -1:
							moves = generate_path.get_external_moves(game_bitboard.white_pieces, game_bitboard.black_pieces, 0)
							moves = filter_moves(moves, piece)
						else:
							moves = generate_path.get_L_moves(game_bitboard.white_pieces, game_bitboard.black_pieces, 0)
						for m in moves:
							bitboard_value_for_filter |= 1 << m.to
						set_board_filter(bitboard_value_for_filter)
						# Check if the piece cannot be moved
						check_if_lost(moves, 0)
				else: if piece.get_size_number() == 50:
					if piece.type < 4:
						if piece.tile_ID == -1:
							moves = generate_path.get_external_moves(game_bitboard.white_pieces, game_bitboard.black_pieces, 1)
							moves = filter_moves(moves, piece)
						else:
							moves = generate_path.get_M_moves(game_bitboard.white_pieces, game_bitboard.black_pieces, 1)
						for m in moves:
							bitboard_value_for_filter |= 1 << m.to
						set_board_filter(bitboard_value_for_filter)
						# Check if the piece cannot be moved
						check_if_lost(moves, 1)
					else:
						if piece.tile_ID == -1:
							moves = generate_path.get_external_moves(game_bitboard.white_pieces, game_bitboard.black_pieces, 0)
							moves = filter_moves(moves, piece)
						else:
							moves = generate_path.get_M_moves(game_bitboard.white_pieces, game_bitboard.black_pieces, 0)
						for m in moves:
							bitboard_value_for_filter |= 1 << m.to
						set_board_filter(bitboard_value_for_filter)
						# Check if the piece cannot be moved
						check_if_lost(moves, 0)
				else: if piece.get_size_number() == 25:
					if piece.type < 4:
						if piece.tile_ID == -1:
							moves = generate_path.get_external_moves(game_bitboard.white_pieces, game_bitboard.black_pieces, 1)
							moves = filter_moves(moves, piece)
						else:
							moves = generate_path.get_S_moves(game_bitboard.white_pieces, game_bitboard.black_pieces, 1)
						for m in moves:
							bitboard_value_for_filter |= 1 << m.to
						set_board_filter(bitboard_value_for_filter)
						# Check if the piece cannot be moved
						check_if_lost(moves, 1)
					else:
						if piece.tile_ID == -1:
							moves = generate_path.get_external_moves(game_bitboard.white_pieces, game_bitboard.black_pieces, 0)
							moves = filter_moves(moves, piece)
						else:
							moves = generate_path.get_S_moves(game_bitboard.white_pieces, game_bitboard.black_pieces, 0)
						for m in moves:
							bitboard_value_for_filter |= 1 << m.to
						set_board_filter(bitboard_value_for_filter)
						# Check if the piece cannot be moved
						check_if_lost(moves, 0)

func filter_moves(moves, piece) -> Array:
	var new_moves = []
	for move in moves:
		if move.size == (piece.type % 4):
			new_moves.append(move)
	return new_moves

func check_if_lost(moves:Array, is_black:bool) -> void:
	# Check if the piece cannot be moved the opponent wins
		if moves.size() == 0:
			if(is_black):
				main.show_finish_message("White wins")
			else:
				main.show_finish_message("Black wins")
			gamestarted = false

func clear_board_filter():
	for i in grid_array:
		i.set_filter()

func set_board_filter(bitmap:int): # here bitmap max value is 2^16-1 and bitmap represents the legal tiles to move to
	for i in range(16):
		if bitmap & 1:
			grid_array[i].set_filter(DataHandler.tile_states.FREE)
		bitmap = bitmap >> 1

func Initialize_gobblet_board():
	var x_off_black = 0
	var x_off_white = 0
	var y_off = 0
	for i in range(3):
		for j in range(4):
			@warning_ignore("integer_division")
			x_off_black = 90 - (((j+1) * 25)/2)
			@warning_ignore("integer_division")
			x_off_white = 90 - (((j+1) * 25)/2) + 860
			y_off = (i * 200) + 40
			var location_black = Vector2(x_off_black, y_off)
			var location_white = Vector2(x_off_white, y_off)
			var piece_type_black
			var piece_type_white
			if(j == 0):
				piece_type_black =  DataHandler.PieceNames.BLACK_25
				piece_type_white = DataHandler.PieceNames.WHITE_25
			elif(j == 1):
				piece_type_black =  DataHandler.PieceNames.BLACK_50
				piece_type_white = DataHandler.PieceNames.WHITE_50
			elif(j == 2):
				piece_type_black =  DataHandler.PieceNames.BLACK_75
				piece_type_white = DataHandler.PieceNames.WHITE_75
			elif(j == 3):
				piece_type_black =  DataHandler.PieceNames.BLACK_100
				piece_type_white = DataHandler.PieceNames.WHITE_100
			add_piece(piece_type_black, location_black, 1, i)
			add_piece(piece_type_white, location_white, 0, i)
			
	while gamestarted and game_mode == 3:
		# pass whose player turn (1st player is white) and depth to play_best_move 
		var move = bot_1.play_best_move(false,bot_1_difficulty) 
		print(move.from_)
		print(move.to)
		print(move.size)
		print(move.isblack)
		if(bot_1_difficulty == 1 and bot_2_difficulty == 1):
				await get_tree().create_timer(1).timeout
		update_board(move)
		# pass whose player turn (2nd player is black) and depth to play_best_move
		if gamestarted: 
			var move_bot2 = bot_2.play_best_move(true,bot_2_difficulty)
			print(move_bot2.from_)
			print(move_bot2.to)
			print(move_bot2.size)
			print(move_bot2.isblack)
			if(bot_1_difficulty == 1 and bot_2_difficulty == 1):
				await get_tree().create_timer(1).timeout
			update_board(move_bot2)

func _on_start_game_button_pressed():
	select_game_mode_label.hide()
	select_ai_1_diff_label.hide()
	select_ai_2_diff_label.hide()
	game_status_label.hide()
	player_turn_label.show()
	player_turn_label.text = "White Turn"
	$StartGameButton.text = "Restart"
	$"../BackgroundMusic".play()
	piece_selected = null
	clear_game()
	bitboard.clear()
	create_tiles()
	gamestarted = true
	Initialize_gobblet_board()

func _on_home_button_pressed():
	select_game_mode_label.show()
	select_ai_1_diff_label.show()
	select_ai_2_diff_label.show()
	game_status_label.hide()
	player_turn_label.hide()
	gamestarted = false
	$StartGameButton.text = "StartGame"
	$"../BackgroundMusic".stop()
	clear_game()
	bitboard.clear()
	#Reset all variables to be made to control the game

func clear_game():
	piece_array = [[], [], [], [],[], [], [], [], [], [], [], [], [], [], [], []]
	black_pieces_array = [[], [], []]
	white_pieces_array = [[], [], []]
	grid_array = []
	gamestarted = false
	get_tree().call_group("all_pieces","queue_free")
	get_tree().call_group("tiles","queue_free")


func _on_HvH_pressed():
	game_mode = 1
	select_game_mode_hvh_button.button_pressed = true
	select_game_mode_hvai_button.button_pressed = false
	select_game_mode_aivai_button.button_pressed = false

func _on_HvAI_pressed():
	game_mode = 2
	select_game_mode_hvh_button.button_pressed = false
	select_game_mode_hvai_button.button_pressed = true
	select_game_mode_aivai_button.button_pressed = false

func _on_a_iv_ai_pressed():
	game_mode = 3
	select_game_mode_hvh_button.button_pressed = false
	select_game_mode_hvai_button.button_pressed = false
	select_game_mode_aivai_button.button_pressed = true

func _on_easy_pressed():
	bot_1_difficulty = 1
	select_ai_1_easy_button.button_pressed = true
	select_ai_1_hard_button.button_pressed = false

func _on_hard_pressed():
	bot_1_difficulty = 3
	select_ai_1_easy_button.button_pressed = false
	select_ai_1_hard_button.button_pressed = true

func _on_easy_bot2_pressed():
	bot_2_difficulty = 1
	select_ai_2_easy_button.button_pressed = true
	select_ai_2_hard_button.button_pressed = false

func _on_hard_bot2_pressed():
	bot_2_difficulty = 3
	select_ai_2_easy_button.button_pressed = false
	select_ai_2_hard_button.button_pressed = true
