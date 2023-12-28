extends Node
extends Move
class_name Bitboard

var white_pieces = [0,0,0,0] #[small, medium, large, XL]
var black_pieces = [0,0,0,0]

func set_board(whites, blacks):
	white_pieces = whites.duplicate()
	black_pieces = blacks.duplicate()

#To return the board and access it accoring to whose turn and what we need to calculate from
func get_board():
	return self

#Get Bitboard for the whole game for both white and black pieces at the same time
func get_board_int():
	var ans = 0
	for i in range(4):
		ans |= white_pieces[i]
	for i in range(4):
		ans |= black_pieces[i]
	return ans

func add_piece(location, piece_type):
	if piece_type < 4:
		black_pieces[piece_type%4] |= 1 << location
	else:
		white_pieces[piece_type%4] |= 1 << location

func remove_piece(location, piece_type):
	if location == -1:
		return
	if piece_type < 4:
		black_pieces[piece_type%4] &= ~(1 << location)
	else:
		white_pieces[piece_type%4] &= ~(1 << location)

func make_move(move, isBlackMove):
	var fromList = []
	if isBlackMove:
		fromList = black_pieces
	else:
		fromList = white_pieces
	var fromBit = (1 << move.from)
	var toBit = (1 << move.to)
	for i in range(3,-1,-1):
		if (fromList[i] & fromBit) != 0:
			fromList[i] &= ~fromBit
			fromList[i] |= toBit
			break

func clear():
	white_pieces = [0,0,0,0]
	black_pieces = [0,0,0,0]

func has_won() -> String:
	var top_view = get_top_view_board()
	var top_view_white = top_view["white"]
	var top_view_black = top_view["black"]
	
	if check_winner(top_view_white):
		return "White wins"
	elif check_winner(top_view_black):
		return "Black wins"
	else:
		return "Game continues"

func check_winner(pieces: Array) -> bool:
	var combined = 0
	for bitboard in pieces:
		combined |= bitboard
	
	# Check horizontal, vertical, and diagonal win conditions
	return check_horizontal(combined) or check_vertical(combined) or check_diagonal(combined)

func check_horizontal(bitboard: int) -> bool:
	# Check all horizontal lines for four in a row
	var mask = 0b0001000100010001
	for _i in range(4):
		if (bitboard & mask) == mask:
			return true
		mask <<= 1
	return false

func check_vertical(bitboard: int) -> bool:
	# Check all vertical lines for four in a row
	var mask = 0b0000000000001111
	for _i in range(4):
		if (bitboard & mask) == mask:
			return true
		mask <<= 4
	return false

func check_diagonal(bitboard: int) -> bool:
	# Check both diagonals for four in a row
	var diag1_mask = 0b1000010000100001
	var diag2_mask = 0b0001001001001000
	return (bitboard & diag1_mask) == diag1_mask or (bitboard & diag2_mask) == diag2_mask

func get_top_view_board() -> Dictionary:
	var top_view_white = [0,0,0,0]
	var top_view_black = [0,0,0,0]

	# Process from largest to smallest pieces
	for size in range(3, -1, -1):
		top_view_white[size] = white_pieces[size] & ~get_covered_bits(black_pieces, size)
		top_view_black[size] = black_pieces[size] & ~get_covered_bits(white_pieces, size)

	return {"white": top_view_white, "black": top_view_black}

func get_covered_bits(opponent_pieces: Array, current_size: int) -> int:
	var covered_bits = 0
	# Any piece larger than the current size can cover it
	for size in range(current_size + 1, 4):
		covered_bits |= opponent_pieces[size]
	return covered_bits

func get_top_view_board_takes_input(white_pieces: Array, black_pieces: Array) -> Dictionary:
	var top_view_white = [0, 0, 0, 0]
	var top_view_black = [0, 0, 0, 0]

	for size in range(3, -1, -1):
		top_view_white[size] = white_pieces[size] & ~get_covered_bits(black_pieces, size)
		top_view_black[size] = black_pieces[size] & ~get_covered_bits(white_pieces, size)

	return {"white": top_view_white, "black": top_view_black}

func generate_move_set(white_pieces: Array, black_pieces: Array, is_black_move: bool) -> Array:
	var possible_moves = []
	var XL_moves = get_XL_moves(white_pieces, black_pieces, is_black_move)
	var L_moves = get_L_moves(white_pieces, black_pieces, is_black_move)
	var M_moves = get_M_moves(white_pieces, black_pieces, is_black_move)
	var S_moves = get_S_moves(white_pieces, black_pieces, is_black_move)
	var normal_external_moves = get_normal_external_moves(white_pieces, black_pieces, is_black_move)

	if XL_moves.size() > 0:
		for move in XL_moves:
			possible_moves.append(move)
	if L_moves.size() > 0:
		for move in L_moves:
			possible_moves.append(move)
	if M_moves.size() > 0:
		for move in M_moves:
			possible_moves.append(move)
	if S_moves.size() > 0:
		for move in S_moves:
			possible_moves.append(move)
	if normal_external_moves.size() > 0:
		for move in normal_external_moves:
			possible_moves.append(move)

	return possible_moves

func get_remaining_pieces(pieces: Array) -> Array:
	var mask = 0b0000000000000001
	var num_of_remaining_pieces = []
	var counter = 0

	for i in range(4):
		for k in range(16):
			if (pieces[i] & mask) == mask:
				counter += 1
			mask <<= 1
		num_of_remaining_pieces.append(3 - counter)
		counter = 0
		mask = 0b0000000000000001

	return num_of_remaining_pieces


func get_available_external_sizes(pieces):
	var mask = 0b0000000000000001
	var available_sizes = []
	var num_of_remaining_pieces = self.get_remaining_pieces(pieces)
	for i in range(4):
		if i < 3:
			if num_of_remaining_pieces[i] != 0 and num_of_remaining_pieces[i+1] < 3:
				available_sizes.append(true)
			else:
				available_sizes.append(false)
		else:
			if num_of_remaining_pieces[i] != 0:
				available_sizes.append(true)
			else:
				available_sizes.append(false)
	return available_sizes

func get_normal_external_moves(white_pieces, black_pieces, is_black_move):
	var mask = 0b0000000000000001
	var external_moves = []
	var num_of_remaining_pieces
	if is_black_move:
		num_of_remaining_pieces = self.get_remaining_pieces(black_pieces)
	else:
		num_of_remaining_pieces = self.get_remaining_pieces(white_pieces)
	for i in range(4):
		if i < 3:
			if num_of_remaining_pieces[i] != 0 and num_of_remaining_pieces[i+1] < 3:
				var moves = self.get_moves_to_empty_cell(white_pieces, black_pieces, i, is_black_move)
				if moves.size() > 0:
					for move in moves:
						external_moves.append(move)
		else:
			var moves = self.get_moves_to_empty_cell(white_pieces, black_pieces, i, is_black_move)
			if moves.size() > 0:
				for move in moves:
					external_moves.append(move)
	return external_moves

func get_moves_to_empty_cell(white_pieces, black_pieces, size, is_black_move):
	var temp_board = []
	var mask = 0b0000000000000001
	var moves = []
	for i in range(4):
		temp_board.append(white_pieces[i] | black_pieces[i])
	if is_black_move:
		for j in range(16):
			if (temp_board[3] & mask) == 0 and (temp_board[2] & mask) == 0 and (temp_board[1] & mask) == 0 and (temp_board[0] & mask) == 0:
				moves.append(Move(-1, j, size, true))
			mask <<= 1
	else:
		for j in range(16):
			if (temp_board[3] & mask) == 0 and (temp_board[2] & mask) == 0 and (temp_board[1] & mask) == 0 and (temp_board[0] & mask) == 0:
				moves.append(Move(-1, j, size, false))
			mask <<= 1
	return moves

func get_XL_moves(white_pieces, black_pieces, is_black_move):
	var temp_board = []
	var mask = 0b0000000000000001
	var mask2 = 0b0000000000000001
	var XL_moves = []
	for i in range(4):
		temp_board.append(white_pieces[i] | black_pieces[i])
	if is_black_move:
		for k in range(16):
			if (black_pieces[3] & mask) == mask:
				for m in range(16):
					if (temp_board[3] & mask2) == 0:
						XL_moves.append(Move(k, m, 3, true))
					mask2 <<= 1
			mask <<= 1
	else:
		for k in range(16):
			if (white_pieces[3] & mask) == mask:
				for m in range(16):
					if (temp_board[3] & mask2) == 0:
						XL_moves.append(Move(k, m, 3, false))
					mask2 <<= 1
			mask <<= 1
	return XL_moves

func get_L_moves(white_pieces, black_pieces, is_black_move):
	var temp_board = []
	var mask = 0b0000000000000001
	var mask2 = 0b0000000000000001
	var L_moves = []
	for i in range(4):
		temp_board.append(white_pieces[i] | black_pieces[i])
	if is_black_move:
		for k in range(16):
			if black_pieces[2] & mask == mask:
				for m in range(16):
					if (temp_board[3] & mask2) == 0 and (temp_board[2] & mask2) == 0:
						L_moves.append(Move.new(k, m, 2, true))
					mask2 <<= 1
			mask <<= 1     
	else:
		for k in range(16):
			if white_pieces[2] & mask == mask:
				for m in range(16):
					if (temp_board[3] & mask2) == 0 and (temp_board[2] & mask2) == 0:
						L_moves.append(Move.new(k, m, 2, false))
					mask2 <<= 1
			mask <<= 1     
	return L_moves
	
func get_M_moves(white_pieces, black_pieces, is_black_move):
	var temp_board = []
	var mask = 0b0000000000000001
	var mask2 = 0b0000000000000001
	var M_moves = []
	for i in range(4):
		temp_board.append(white_pieces[i] | black_pieces[i])
	if is_black_move:
		for k in range(16):
			if black_pieces[1] & mask == mask:
				for m in range(16):
					if (temp_board[3] & mask2) == 0 and (temp_board[2] & mask2) == 0 and (temp_board[1] & mask2) == 0:
						M_moves.append(Move.new(k, m, 1, true))
					mask2 <<= 1
			mask <<= 1     
	else:
		for k in range(16):
			if white_pieces[1] & mask == mask:
				for m in range(16):
					if (temp_board[3] & mask2) == 0 and (temp_board[2] & mask2) == 0 and (temp_board[1] & mask2) == 0:
						M_moves.append(Move.new(k, m, 1, false))
					mask2 <<= 1
			mask <<= 1     
	return M_moves
	
func get_S_moves(white_pieces, black_pieces, is_black_move):
		var temp_board = []
		var mask = 0b0000000000000001
		var mask2 = 0b0000000000000001
		var S_moves = []
		for i in range(4):
			temp_board.append(white_pieces[i] | black_pieces[i])
		if is_black_move:
			for k in range(16):
				if black_pieces[0] & mask == mask:
					for m in range(16):
						if (temp_board[3] & mask2) == 0 and (temp_board[2] & mask2) == 0 and (temp_board[1] & mask2) == 0 and (temp_board[0] & mask2) == 0:
							S_moves.append(Move.new(k, m, 1, true))
						mask2 <<= 1
				mask <<= 1     
		else:
			for k in range(16):
				if white_pieces[0] & mask == mask:
					for m in range(16):
						if (temp_board[3] & mask2) == 0 and (temp_board[2] & mask2) == 0 and (temp_board[1] & mask2) == 0 and (temp_board[0] & mask2) == 0:
							S_moves.append(Move.new(k, m, 1, false))
						mask2 <<= 1
				mask <<= 1     
		return S_moves
				
#will use get moves functions then seperate each option and add them to the layer
#Returns A list of legal moves which is one layer of the tree.
#will be called recursively
#Watch ep3 (Generating paths)
#All must watch last video , implementing the ai using C#