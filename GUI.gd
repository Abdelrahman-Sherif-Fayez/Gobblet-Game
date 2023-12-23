extends Control

@onready var tile_scene = preload("res://tile.tscn")
@onready var board_grid = $GobbletBoard/BoardGrid
@onready var piece_scene = preload("res://piece.tscn")
@onready var gobblet_board = $GobbletBoard
@onready var bitboard = $Bitboard
@onready var generate_path = $GeneratePath
@onready var bot = $Bot

var grid_array := []
var black_pieces_array := [[], [], []]
var white_pieces_array := [[], [], []]
var piece_array := [[], [], [], [],[], [], [], [], [], [], [], [], [], [], [], []] # Array that contains the top piece of each of the 16 tiles
var piece_selected = null

# Called when the node enters the scene tree for the first time.
func _ready():
	var x_off = 0
	var y_off = 0
	for i in range(4):
		x_off = 0
		y_off = (i*162)
		for j in range(4):
			x_off = (j*162)
			var position_off = Vector2(x_off, y_off)
			create_tile(position_off)
	#piece_array.resize(16)
	#piece_array.fill(0)

func _process(_delta):
	if Input.is_action_just_pressed("mouse_right") and piece_selected:
		piece_selected = null
		clear_board_filter()

func create_tile(pos_vector):
	var new_tile = tile_scene.instantiate()
	new_tile.tile_ID = grid_array.size()
	new_tile.position += pos_vector
	board_grid.add_child(new_tile)
	grid_array.push_back(new_tile)
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

# A function to move the selected piece to the clicked tile
func move_piece(piece, location)->void:  #location is an index 
	#condition if new piece moved from outside into the board
	if piece.tile_ID == -1:
		piece_array[location].push_back(piece)
		#print(piece_array[location])
	else:
		piece_array[piece.tile_ID].pop_front()
		piece_array[location].push_back(piece)
	remove_piece_from_bitboard(piece)
	piece.tile_ID = location
	self.move_child(piece, -1)
	var tween = get_tree().create_tween()
	var icon_offset = piece.get_size()
	icon_offset.x = icon_offset.x / 2
	icon_offset.y = icon_offset.y /  2
	tween.tween_property(piece, "global_position", grid_array[location].global_position - icon_offset, 0.5)
	bitboard.add_piece(location, piece.type)

func remove_piece_from_bitboard(piece):
	bitboard.remove_piece(piece.tile_ID, piece.type)

func add_piece(piece_type, location, is_black, stack_no) -> void: #location is an index 
	var new_piece = piece_scene.instantiate()
	self.add_child(new_piece)
	if is_black:
		black_pieces_array[stack_no].push_back(new_piece)
	else:
		white_pieces_array[stack_no].push_back(new_piece)
	new_piece.type = piece_type
	new_piece.tile_ID = -1
	new_piece.load_icon(piece_type)
	#var icon_offset = new_piece.get_size()
	#icon_offset.x = icon_offset.x / 2
	#icon_offset.y = icon_offset.y /  2
	new_piece.global_position = location
	#piece_array[location] = new_piece
	new_piece.piece_selected.connect(_on_piece_selected)

func _on_piece_selected(piece):
	if piece_selected:
		_on_tile_clicked(grid_array[piece.tile_ID])
	else:
		piece_selected = piece
		var board = bitboard.get_board()
		#print(bitboard.get_board_int())
		if piece.get_size_number() == 100:
			set_board_filter(generate_path.get_XL_moves(piece.tile_ID, board))
		else: if piece.get_size_number() == 75:
			set_board_filter(generate_path.get_L_moves(piece.tile_ID, board))
		else: if piece.get_size_number() == 50:
			set_board_filter(generate_path.get_M_moves(piece.tile_ID, board))
		else: if piece.get_size_number() == 25:
			set_board_filter(generate_path.get_S_moves(piece.tile_ID, board))

func clear_board_filter():
	for i in grid_array:
		i.set_filter()

func set_board_filter(bitmap:int): # here bitmap max value is 2^16-1
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


func _on_test_button_pressed():
	#Initializing Black and White Pieces (3 stacks with 4 pieces for each)
	Initialize_gobblet_board()
	set_board_filter(5)


func _on_start_game_button_pressed():
	piece_selected = null
	clear_piece_array()
	clear_board_filter()
	bitboard.clear()
	piece_array = [[], [], [], [],[], [], [], [], [], [], [], [], [], [], [], []]
	Initialize_gobblet_board()

func clear_piece_array():
	for i in black_pieces_array:
		if i:
			while len(i) > 0:
				i[0].queue_free()
				i.pop_front()
	for i in white_pieces_array:
		if i:
			while len(i) > 0:
				i[0].queue_free()
				i.pop_front()

func update_board(move):
	pass
