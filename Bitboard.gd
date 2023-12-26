extends Node

class_name Bitboard

var white_pieces = [0,0,0,0] #[small, medium, large, XL]
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

func generate_move_set(isBlackMove):
	pass
#will use get moves functions then seperate each option and add them to the layer
#Returns A list of legal moves which is one layer of the tree.
#will be called recursively
#Watch ep3 (Generating paths)
#All must watch last video , implementing the ai using C#
