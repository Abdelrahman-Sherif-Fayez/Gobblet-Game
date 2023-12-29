extends Node

@onready var bitboard = $"../Bitboard"

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
			mask <<= 1
	else:
		for k in range(16):
			if (white_pieces[3] & mask) == mask:
				for m in range(16):
					if (temp_board[3] & mask2) == 0:
						XL_moves.append(Move.new(k, m, 3, false))
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

func get_normal_external_moves(white_pieces, black_pieces, is_black_move):
	var mask = 0b0000000000000001
	var external_moves = []
	var num_of_remaining_pieces
	if is_black_move:
		num_of_remaining_pieces = bitboard.get_remaining_pieces(black_pieces)
	else:
		num_of_remaining_pieces = bitboard.get_remaining_pieces(white_pieces)
	for i in range(4):
		if i < 3:
			if num_of_remaining_pieces[i] != 0 and num_of_remaining_pieces[i+1] < 3:
				var moves = bitboard.get_moves_to_empty_cell(white_pieces, black_pieces, i, is_black_move)
				if moves.size() > 0:
					for move in moves:
						external_moves.append(move)
		else:
			var moves = bitboard.get_moves_to_empty_cell(white_pieces, black_pieces, i, is_black_move)
			if moves.size() > 0:
				for move in moves:
					external_moves.append(move)
	return external_moves
