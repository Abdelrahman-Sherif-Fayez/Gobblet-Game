extends Node
@onready var updated_bitboard = $"../Bitboard"

const MAX_VALUE = 999999
const MIN_VALUE = -999999

var new_bot_bitboard_object

var bitboard
var whitepieces
var blackpieces 

func set_board(bitboardGame):
	bitboard = bitboardGame

func play_next_move(move, isBlackMove):

	if not isBlackMove:
		whitepieces[move.size%4] |= 1 << move.to
		#var newwhitepieces = whitepieces
	elif isBlackMove:
		blackpieces[move.size%4] |= 1 << move.to
		#var newwhitepieces = white_pieces

	#return Move.new(-1, 3, 100*100, 0) # for testing update_board (Working)
	#will use search moves function and use make move function
	#will update the bitboard with the move 

func play_best_move(depth): 
	new_bot_bitboard_object = updated_bitboard.duplicate()
	new_bot_bitboard_object.set_board(updated_bitboard.white_pieces, updated_bitboard.black_pieces)
	whitepieces = new_bot_bitboard_object.white_pieces
	blackpieces = new_bot_bitboard_object.black_pieces
	print(whitepieces," ", blackpieces)
	var possible_moves = updated_bitboard.generate_move_set(whitepieces, blackpieces, true)
	var eval = search_moves(true, possible_moves, depth, MIN_VALUE, MAX_VALUE)
	print(eval[0]," ", eval[1])
	return eval[1]

func search_moves(isBlackMove, possible_moves, depth, alpha, beta):
	##will use generate move set fuction recursively and will prune and use eval function 
	##to select best move acc to prunning
	if depth == 0 or not possible_moves: # Evaluation based on the current bitboard of the game when move or set of moves played
		bitboard = updated_bitboard.get_board_int()
		return randi() % 100

	if not isBlackMove: #white -> Maximizer (changes alpha)
		var max_eval = MIN_VALUE
		var best_move
		var eval
		for move in possible_moves: 
			play_next_move(move, false)
			if depth - 1 != 0:
				var new_possible_moves = updated_bitboard.generate_move_set(whitepieces, blackpieces, true)
				eval = search_moves(true, new_possible_moves, depth - 1, alpha, beta)
			else: # if depth - 1 is zero -> evaluate the value of the current move immediately without expanding its moves
				eval = search_moves(true, [], depth - 1, alpha, beta)
			if depth - 1 == 0:
				max_eval = max(max_eval, eval)
			else:
				max_eval = max(max_eval, eval[0])
			alpha = max(alpha, max_eval)
			if beta <= alpha:
				break  # Beta cut-off
			if depth - 1 == 0:
				if eval == max_eval:
					best_move = move
			else:
				if eval[0] == max_eval:
					best_move = move
		return [max_eval, best_move]
		
	else: #black
		var best_move
		var eval
		var min_eval = MAX_VALUE
		for move in possible_moves:
			play_next_move(move, true)
			if depth - 1 != 0:
				var new_possible_moves = updated_bitboard.generate_move_set(whitepieces, blackpieces, false)
				eval = search_moves(false, new_possible_moves, depth - 1, alpha, beta)
			else:
				eval = search_moves(false, [], depth - 1, alpha, beta)
				
			if depth -1 == 0:
				min_eval = min(min_eval, eval)
			elif depth > 1:
				min_eval = min(min_eval, eval[0])
			beta = min(beta, min_eval)
			if beta <= alpha:
				break  # Beta cut-off
			if depth - 1 == 0:
				if eval == min_eval:
					best_move = move
			else:
				if eval[0] == min_eval:
					best_move = move
		return [min_eval, best_move]

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
#
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

#Our Old Implementation

#func evaluate_position(isBlackMove, bitboard)-> float:
	#var final_score = 0
	#var directions = get_all_directions(bitboard)
	#for direction in directions:
		#var direction_score = evaluate_direction(direction, isBlackMove)
		#final_score += direction_score
#
	#return final_score

#func evaluate_direction(direction, isBlackMove) -> float:
	#var direction_product = 1
#
	#for cell in direction:
		#var cell_score = 0
		#if cell.is_empty():
			#cell_score = 1
		#elif cell.top_piece.color == "Black":
			#cell_score = cell.top_piece.size * 10
			#if not isBlackMove:
				#cell_score = -cell_score
		#else:
			#cell_score = cell.top_piece.size * 10
			#if isBlackMove:
				#cell_score = -cell_score
#
		## Multiply the cell score with the current product
		#direction_product *= cell_score
#
	#return direction_product

#func get_all_directions(bitboard):
	#var directions = []
	#
	#print(bitboard)
	## Add all rows
	#for i in range(4):
		#directions.append(bitboard[i])
#
	## Add all columns
	#for i in range(4):
		#var column = []
		#for j in range(4):
			#column.append(bitboard[j][i])
		#directions.append(column)
#
	## Add diagonal (top-left to bottom-right)
	#var diagonal1 = []
	#for i in range(4):
		#diagonal1.append(bitboard[i][i])
	#directions.append(diagonal1)
#
	## Add diagonal (top-right to bottom-left)
	#var diagonal2 = []
	#for i in range(4):
		#diagonal2.append(bitboard[i][3 - i])
	#directions.append(diagonal2)
#
	#return directions
