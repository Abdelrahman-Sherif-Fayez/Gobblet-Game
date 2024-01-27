extends Node
@onready var bitboard = $"../Bitboard"

const MAX_VALUE = 999999
const MIN_VALUE = -999999

var new_bot_bitboard_object
var max_depth
var current_move

func set_board(bitboardGame):
	bitboard = bitboardGame

#Takes the player's turn and depth and will use search_moves to find the best move to play
func play_best_move(isBlackMove, depth): 
	new_bot_bitboard_object = bitboard.duplicate()
	new_bot_bitboard_object.set_board(bitboard.white_pieces, bitboard.black_pieces)
	print(new_bot_bitboard_object.white_pieces," ", new_bot_bitboard_object.black_pieces)
	max_depth = depth
	search_moves(isBlackMove, new_bot_bitboard_object, max_depth, MIN_VALUE, MAX_VALUE)
	var move = current_move
	print(move)
	return move

##will use generate move set fuction and recursively call itself and will prune and use eval function 
##to select best move according to prunning
func search_moves(isBlackMove, search_board, depth, alpha, beta):
	if depth == 0 or search_board.has_won() == "White wins" or search_board.has_won() == "Black wins":#Evaluation based on the bitboard of the game when move or set of moves played
		return evaluate_position(isBlackMove, search_board)
	
	var possible_moves = bitboard.generate_move_set(search_board.white_pieces, search_board.black_pieces, isBlackMove)
	
	if not isBlackMove: #White Player which is the maximizer
		var max_eval = MIN_VALUE
		for move in possible_moves:
			var move_bitboard_object = search_board.duplicate()
			move_bitboard_object.set_board(search_board.white_pieces, search_board.black_pieces)
			move_bitboard_object.make_move(move, false)
			var eval = search_moves(true, move_bitboard_object, depth-1, alpha, beta)
			max_eval = max(max_eval, eval)
			alpha = max(alpha, eval)
			if beta <= alpha: # cutoff
				break
			if(depth == max_depth and eval >= alpha):
				print(move)
				current_move = move
		return max_eval

	elif isBlackMove:
		var min_eval = MAX_VALUE
		for move in possible_moves:
			var move_bitboard_object = search_board.duplicate()
			move_bitboard_object.set_board(search_board.white_pieces, search_board.black_pieces)
			move_bitboard_object.make_move(move, true)
			var eval = search_moves(false, move_bitboard_object, depth-1, alpha, beta)
			min_eval = min(min_eval, eval)
			beta = min(beta, eval)
			if beta <= alpha: # cutoff
				break
			if(depth == max_depth and eval <= beta):
				print(move)
				current_move = move
		return min_eval

#Our New Implementation

func evaluate_position(is_black_move , Search_Board_object):
	var white_pieces = Search_Board_object.white_pieces
	var black_pieces = Search_Board_object.black_pieces
	var diagonal_mask1 = 0b1000010000100001
	var diagonal_mask2 = 0b0001001001001000
	var diagonal_masks = [diagonal_mask1 , diagonal_mask2]
	var row_mask = 0b0000000000001111 
	var column_msk = 0b0001000100010001
	var iterator_mask1 = 0b0000000000000001
	var iterator_mask2 = 0b0000000000000001
	var iterator_mask3 = 0b0000000000000001
	var result = Search_Board_object.get_top_view_board_takes_input(white_pieces, black_pieces)
	var white_top_view = result["white"]
	var black_top_view = result["black"]
	var top_board = 0
	var mult_temp = 1
	var final_score = 0
	var temp_accumalator = 0
	var current_top_view_array
	if is_black_move:
		current_top_view_array = black_top_view 
		for i in range(4):
			top_board |= black_top_view[i]
	else:
		current_top_view_array = white_top_view
		for i in range(4):
			top_board |= white_top_view[i]

	for dm in diagonal_masks:
		var temp = top_board & dm
		print("temp")
		print(temp)
		for k in range(16):
			if (temp & iterator_mask1) == iterator_mask1:
					if (current_top_view_array[3] & iterator_mask1) == iterator_mask1:
						mult_temp *= 40
						final_score += mult_temp
					elif (current_top_view_array[2] & iterator_mask1) == iterator_mask1:
						mult_temp *= 30
						final_score += mult_temp
					elif (current_top_view_array[1] & iterator_mask1) == iterator_mask1:
						mult_temp *= 20
						final_score += mult_temp
					elif (current_top_view_array[0] & iterator_mask1) == iterator_mask1:
						mult_temp *= 10
						final_score += mult_temp
					print("mult_temp")
					print(mult_temp)
			iterator_mask1 <<=1
		# temp_accumalator = mult_temp
		iterator_mask1 = 0b0000000000000001
		mult_temp = 1
	# final_score += temp_accumalator
	print("final_score")
	print(final_score)
	var temp_rm = row_mask
	mult_temp = 1
	for i in range(4):
		var temp = top_board & temp_rm
		for k in range(16):
			if (temp & iterator_mask2) == iterator_mask2:
				if (current_top_view_array[3] & iterator_mask2) == iterator_mask2:
					mult_temp *= 40
					final_score += mult_temp
				elif (current_top_view_array[2] & iterator_mask2) == iterator_mask2:
					mult_temp *= 30
					final_score += mult_temp
				elif (current_top_view_array[1] & iterator_mask2) == iterator_mask2:
					mult_temp *= 20
					final_score += mult_temp
				elif (current_top_view_array[0] & iterator_mask2) == iterator_mask2:
					mult_temp *= 10
					final_score += mult_temp
			iterator_mask2 <<=1
		iterator_mask2 = 0b0000000000000001
		# temp_accumalator = mult_temp
		mult_temp = 1
		temp_rm <<= 4
	# final_score += temp_accumalator
	print("final_score")
	print(final_score)
	var temp_cm = column_msk
	mult_temp = 1
	for i in range(4):

		var temp = top_board & temp_cm
		for k in range(16):
			if (temp & iterator_mask3) == iterator_mask3:
				if (current_top_view_array[3] & iterator_mask3) == iterator_mask3:
					mult_temp *= 40
					final_score += mult_temp
				elif (current_top_view_array[2] & iterator_mask3) == iterator_mask3:
					mult_temp *= 30
					final_score += mult_temp
				elif (current_top_view_array[1] & iterator_mask3) == iterator_mask3:
					mult_temp *= 20
					final_score += mult_temp
				elif (current_top_view_array[0] & iterator_mask3) == iterator_mask3:
					mult_temp *= 10
					final_score += mult_temp
			iterator_mask3 <<=1
		# temp_accumalator = mult_temp
		iterator_mask3 = 0b0000000000000001
		mult_temp = 1 
		temp_cm <<= 1
	# final_score += temp_accumalator
	print("final_score")
	print(final_score)
	return final_score
