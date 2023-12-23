extends Node

class_name Bitboard

var white_pieces = [0,0,0,0]
var black_pieces = [0,0,0,0]

func set_board(whites, blacks):
	white_pieces = whites.duplicate()
	black_pieces = blacks.duplicate()

func get_board():
	return self
	
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

func clear():
	white_pieces = [0,0,0,0]
	black_pieces = [0,0,0,0]
	
func generate_move_set(isBlackMove):
	pass
