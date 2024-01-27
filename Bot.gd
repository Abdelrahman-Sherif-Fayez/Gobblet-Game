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
		return randi() % 100
	
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

#func evaluate_position(isBlackMove, board_array)-> float:
	#if has_won() == "Black wins" or has_won() == "White wins":
		#return MIN_VALUE 
	#elif is_black_move: 
		#return MAX_VALUE
	#var final_score = 0
	#var directions = get_all_directions(board_array)
	#for direction in directions:
		#var direction_score = evaluate_direction(direction, isBlackMove)
		#final_score += direction_score
#
	#return final_score

#func evaluate_position(isBlackMove, board_array)-> float:
	# if has_won() == "Black wins" or has_won() == "White wins":
	#     return MIN_VALUE if is_black_move else MAX_VALUE


#func top_piece(cell):
	#var top_piece = cell[-1]
	#return top_piece
#
#func evaluate_direction(direction, isBlackMove) -> float:
	#var direction_product = 1
#
	#for cell in direction:
		#var cell_score = 0
		#if cell.size()==0: # Empty cell
			#cell_score = 1
		#elif top_piece(cell).type == 1:	# 1 is black piece
			#cell_score = top_piece(cell).size * 10
			#if not isBlackMove:
				#cell_score = -cell_score
		#else:
			#cell_score = top_piece(cell).size * 10
			#if isBlackMove:
				#cell_score = -cell_score
#
		## Multiply the cell score with the current product
		#direction_product *= cell_score
#
	#return direction_product
#
#func get_all_directions(board_array):
	#var directions = []
#
	## Add all rows
	#for i in range(4):
		#directions.append(board_array[i])
#
	## Add all columns
	#for i in range(4):
		#var column = []
		#for j in range(4):
			#column.append(board_array[j][i])
		#directions.append(column)
#
	## Add diagonal (top-left to bottom-right)
	#var diagonal1 = []
	#for i in range(4):
		#diagonal1.append(board_array[i][i])
	#directions.append(diagonal1)
#
	## Add diagonal (top-right to bottom-left)
	#var diagonal2 = []
	#for i in range(4):
		#diagonal2.append(board_array[i][3 - i])
	#directions.append(diagonal2)
#
	#return directions


