extends Node
extends Bitboard

var bitboard
const MAX_VALUE = 999999
const MIN_VALUE = -999999

func set_board(bitboardGame):
	bitboard = bitboardGame

func play_next_move():
	#return Move.new(-1, 3, 100*100, 0) # for testing update_board (Working)
	pass
#will use search moves function and use make move function
#will update the bitboard with the move 

#func search_moves(isBlackMove, possible_moves, depth, alpha, beta):
	##will use generate move set fuction recursively and will prune and use eval function 
	##to select best move acc to prunning
	##still needs to be turned to gadot 
	#if depth == 0 or not possible_moves:
		#return evaluate_position(isBlackMove, possible_moves), None
#
	#if not isBlackMove:
		#max_eval = float('-inf')
		#best_move = None
		#for move in possible_moves:
			#new_possible_moves = generate_moves(apply_move(possible_moves, move), color)
			#eval, _ = search_moves(new_possible_moves, depth - 1, alpha, beta, False, color)
			#max_eval = max(max_eval, eval)
			#alpha = max(alpha, eval)
			#if beta <= alpha:
				#break  # Beta cut-off
			#if eval == max_eval:
				#best_move = move
		#return max_eval, best_move
	#else:
		#min_eval = float('inf')
		#best_move = None
		#for move in possible_moves:
			#new_possible_moves = generate_moves(apply_move(possible_moves, move), color)
			#eval, _ = minimax_with_alpha_beta_pruning_moves(new_possible_moves, depth - 1, alpha, beta, True, color)
			#min_eval = min(min_eval, eval)
			#beta = min(beta, eval)
			#if beta <= alpha:
				#break  # Alpha cut-off
			#if eval == min_eval:
				#best_move = move
		#return min_eval, best_move
#
#func evaluate_position(isBlackMove, board_array)-> float:
	# if has_won() == "Black wins" or has_won() == "White wins":
    #     return MIN_VALUE if is_black_move else MAX_VALUE
	#var final_score = 0
	#var directions = get_all_directions(board_array)
	#for direction in directions:
		#var direction_score = evaluate_direction(direction, isBlackMove)
		#final_score += direction_score
#
	#return final_score
func top_piece(cell):
	var top_piece = cell[-1]
	return top_piece

func evaluate_direction(direction, isBlackMove) -> float:
	var direction_product = 1

	for cell in direction:
		var cell_score = 0
		if cell.is_empty():
			cell_score = 1
		elif top_piece(cell).type == 1:	# 1 is black piece
			cell_score = top_piece(cell).size * 10
			if not isBlackMove:
				cell_score = -cell_score
		else:
			cell_score = top_piece(cell).size * 10
			if isBlackMove:
				cell_score = -cell_score

		# Multiply the cell score with the current product
		direction_product *= cell_score

	return direction_product

func get_all_directions(board_array):
	var directions = []

	# Add all rows
	for i in range(4):
		directions.append(board_array[i])

	# Add all columns
	for i in range(4):
		var column = []
		for j in range(4):
			column.append(board_array[j][i])
		directions.append(column)

	# Add diagonal (top-left to bottom-right)
	var diagonal1 = []
	for i in range(4):
		diagonal1.append(board_array[i][i])
	directions.append(diagonal1)

	# Add diagonal (top-right to bottom-left)
	var diagonal2 = []
	for i in range(4):
		diagonal2.append(board_array[i][3 - i])
	directions.append(diagonal2)

	return directions
