extends Node
@onready var bitboard_path = $"../Bitboard"

#Same person of gen move set
#takes bitboard and returns interger formed of ones placed in the cells of legal moves
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
						XL_moves.append(Move.new(k, m, 3, true))
					mask2 <<= 1
				mask2 = 0b0000000000000001
			mask <<= 1
	else:
		for k in range(16):
			if (white_pieces[3] & mask) == mask:
				for m in range(16):
					if (temp_board[3] & mask2) == 0:
						XL_moves.append(Move.new(k, m, 3, false))
					mask2 <<= 1
				mask2 = 0b0000000000000001
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
				mask2 = 0b0000000000000001
			mask <<= 1     
	else:
		for k in range(16):
			if white_pieces[2] & mask == mask:
				for m in range(16):
					if (temp_board[3] & mask2) == 0 and (temp_board[2] & mask2) == 0:
						L_moves.append(Move.new(k, m, 2, false))
					mask2 <<= 1
				mask2 = 0b0000000000000001
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
				mask2 = 0b0000000000000001
			mask <<= 1     
	else:
		for k in range(16):
			if white_pieces[1] & mask == mask:
				for m in range(16):
					if (temp_board[3] & mask2) == 0 and (temp_board[2] & mask2) == 0 and (temp_board[1] & mask2) == 0:
						M_moves.append(Move.new(k, m, 1, false))
					mask2 <<= 1
				mask2 = 0b0000000000000001
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
						S_moves.append(Move.new(k, m, 0, true))
					mask2 <<= 1
				mask2 = 0b0000000000000001
			mask <<= 1     
	else:
		for k in range(16):
			if white_pieces[0] & mask == mask:
				for m in range(16):
					if (temp_board[3] & mask2) == 0 and (temp_board[2] & mask2) == 0 and (temp_board[1] & mask2) == 0 and (temp_board[0] & mask2) == 0:
						S_moves.append(Move.new(k, m, 0, false))
					mask2 <<= 1
				mask2 = 0b0000000000000001
			mask <<= 1     
	return S_moves

func get_external_moves(white_pieces, black_pieces, is_black_move):
	var mask = 0b0000000000000001
	var external_moves = []
	var num_of_remaining_pieces
	if is_black_move:
		num_of_remaining_pieces = get_remaining_pieces(black_pieces)
	else:
		num_of_remaining_pieces = get_remaining_pieces(white_pieces)
	for i in range(4):
		if i < 3:
			if num_of_remaining_pieces[i] != 0 and num_of_remaining_pieces[i+1] < num_of_remaining_pieces[i]:
				var moves = get_moves_to_empty_cell(white_pieces, black_pieces, i, is_black_move)
				if moves.size() > 0:
					for move in moves:
						external_moves.append(move)
		else:
			if num_of_remaining_pieces[i] != 0:
				var moves = get_moves_to_empty_cell(white_pieces, black_pieces, i, is_black_move)
				if moves.size() > 0:
					for move in moves:
						external_moves.append(move)
	var moves = get_external_gobbeling_moves(white_pieces, black_pieces, is_black_move)
	if moves.size() > 0:
		for move in moves:
			external_moves.append(move)
	return external_moves

	
# get external moves to empty cells
func get_moves_to_empty_cell(white_pieces, black_pieces, size, is_black_move):
	var temp_board = []
	var mask = 0b0000000000000001
	var moves = []
	for i in range(4):
		temp_board.append(white_pieces[i] | black_pieces[i])
	if is_black_move:
		for j in range(16):
			if (temp_board[3] & mask) == 0 and (temp_board[2] & mask) == 0 and (temp_board[1] & mask) == 0 and (temp_board[0] & mask) == 0:
				moves.append(Move.new(-1, j, size, true))
			mask <<= 1
	else:
		for j in range(16):
			if (temp_board[3] & mask) == 0 and (temp_board[2] & mask) == 0 and (temp_board[1] & mask) == 0 and (temp_board[0] & mask) == 0:
				moves.append(Move.new(-1, j, size, false))
			mask <<= 1
	return moves
	
func get_available_external_sizes(pieces):
	var mask = 0b0000000000000001
	var available_sizes = []
	var num_of_remaining_pieces = get_remaining_pieces(pieces)
	for i in range(4):
		if i < 3:
			if num_of_remaining_pieces[i] != 0 and num_of_remaining_pieces[i+1] < num_of_remaining_pieces[i]:
				available_sizes.append(true)
			else:
				available_sizes.append(false)
		else:
			if num_of_remaining_pieces[i] != 0:
				available_sizes.append(true)
			else:
				available_sizes.append(false)
	return available_sizes

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

func get_external_gobbeling_moves(white_pieces, black_pieces, is_black_move):
	var external_gobbeling_moves = []
	var temp_moves = []
	var result = bitboard_path.get_top_view_board_takes_input(white_pieces, black_pieces)
	var white_top_view = result["white"]
	var black_top_view = result["black"]
	var top_board = 0
	var diagonal_mask1 = 0b0000010000100001
	var diagonal_mask2 = 0b1000010000100000
	var diagonal_mask3 = 0b0000001001001000
	var diagonal_mask4 = 0b0001001001000000
	var diagonal_mask5 = 0b1000000000100001
	var diagonal_mask6 = 0b1000010000000001
	var diagonal_mask7 = 0b0001000001001000
	var diagonal_mask8 = 0b0001001000001000
	var diagonal_masks = [diagonal_mask1,diagonal_mask2,diagonal_mask3,diagonal_mask4,
						  diagonal_mask5,diagonal_mask6,diagonal_mask7,diagonal_mask8]
	var row_mask1 = 0b0000000000000111
	var row_mask2 = 0b0000000000001110
	var	row_mask3 = 0b0000000000001101
	var row_mask4 = 0b0000000000001011
	var row_masks = [row_mask1,row_mask2,row_mask3,row_mask4]
	var column_mask1 = 0b0000000100010001
	var column_mask2 = 0b0001000100010000
	var	column_mask3 = 0b0001000100000001
	var column_mask4 = 0b0001000000010001
	var column_masks = [column_mask1,column_mask2,column_mask3,column_mask4]

	var iterator_mask1 = 0b0000000000000001
	var iterator_mask2 = 0b0000000000000001
	var current_piece_size = -1
	var counter = 0
	var current_top_view_array
	var available_sizes

	if is_black_move:
		available_sizes = get_available_external_sizes(black_pieces)
		current_top_view_array = white_top_view
		for i in range(4):
			top_board |= white_top_view[i]
	else:
		current_top_view_array = black_top_view
		available_sizes = get_available_external_sizes(white_pieces)
		for i in range(4):
			top_board |= black_top_view[i]
			
	for dm in diagonal_masks:
			if top_board & dm == dm:
				temp_moves = self.helper_get_external_gobbeling_moves(dm,current_top_view_array,available_sizes,is_black_move)
				if len(temp_moves) > 0 :
					for move in temp_moves:
						external_gobbeling_moves.append(move)   
	for rm in row_masks:
		var temp_rm = rm
		for i in range(4):
			if top_board & temp_rm == temp_rm:
				temp_moves = self.helper_get_external_gobbeling_moves(temp_rm,current_top_view_array,available_sizes,is_black_move)
				if len(temp_moves) > 0 :
					for move in temp_moves:
						external_gobbeling_moves.append(move)
			temp_rm <<= 4
	for cm in column_masks:
		var temp_cm = cm
		for i in range(4):
			if top_board & temp_cm == temp_cm:
				temp_moves = self.helper_get_external_gobbeling_moves(temp_cm,current_top_view_array,available_sizes,is_black_move)
				if len(temp_moves) > 0 :
					for move in temp_moves:
						external_gobbeling_moves.append(move)
			temp_cm <<= 1
	return external_gobbeling_moves

func remove_duplicates(moves_list):
	var unique_moves = []
	var seen_moves = {}

	for move in moves_list:
		var move_tuple = [move.from_ , move.to, move.size, move.isblack]

		if move_tuple not in seen_moves:
			seen_moves[move_tuple] = true
			unique_moves.append(move)

	return unique_moves


func helper_get_external_gobbeling_moves(three_consecutive_pieces_mask, current_top_view_array, available_sizes, is_black_move):
	var temp_external_gobbeling_moves = []
	var counter = 0
	var iterator_mask1 = 0b0000000000000001
	var current_piece_size = -1

	for i in range(16):
		if counter == 3:
			break
		else:
			if (three_consecutive_pieces_mask & iterator_mask1) == iterator_mask1:
				counter += 1
				for j in range(3, -1, -1):
					if iterator_mask1 & current_top_view_array[j] == iterator_mask1:
						current_piece_size = j
						for k in range(current_piece_size + 1, 4):
							if available_sizes[k]: #[f, t, t, f]
								temp_external_gobbeling_moves.append(Move.new(-1, i, k, is_black_move))
						break
		iterator_mask1 <<= 1
	return temp_external_gobbeling_moves
	
