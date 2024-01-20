extends Node
@onready var updated_bitboard = $"../Bitboard"
@onready var generate_path = $"../GeneratePath"
var bitboard
var whitepieces = updated_bitboard.white_pieces
var blackpieces = updated_bitboard.black_pieces
func set_board(bitboardGame):
	bitboard = bitboardGame

func play_next_move(move, isBlackMove):

	if not isBlackMove:
		whitepieces.make_move(move, isBlackMove)
		#var newwhitepieces = white_pieces.copy()
	elif isBlackMove:
		blackpieces.make_move(move, isBlackMove)
		#var newwhitepieces = white_pieces.copy()

	#return Move.new(-1, 3, 100*100, 0) # for testing update_board (Working)
	#will use search moves function and use make move function
	#will update the bitboard with the move 

func play_best_move(depth):
	var possible_moves = generate_path.generate_move_set(whitepieces, blackpieces, true)
	var eval = search_moves(true, possible_moves, depth, float('-inf'), float('inf'))
	return eval[1]

func search_moves(isBlackMove, possible_moves, depth, alpha, beta):
	##will use generate move set fuction recursively and will prune and use eval function 
	##to select best move acc to prunning
	##still needs to be turned to gadot 
	if depth == 0 or not possible_moves:
		return evaluate_position(isBlackMove, possible_moves)
#
	if not isBlackMove:
		var max_eval = float('-inf')
		var best_move
		for move in possible_moves: 
			play_next_move(move, false)
			var new_possible_moves = generate_path.generate_move_set(whitepieces, blackpieces, isBlackMove)
			var eval = search_moves(isBlackMove, new_possible_moves, depth - 1, alpha, beta)
			max_eval = max(max_eval, eval[0])
			alpha = max(alpha, eval[0])
			if beta <= alpha:
				break  # Beta cut-off
			if eval[0] == max_eval:
				best_move = move
		return [max_eval, best_move]
	else:
		var best_move
		var min_eval = float('inf')
		for move in possible_moves:
			play_next_move(move, true)
			var new_possible_moves = generate_path.generate_move_set(whitepieces, blackpieces, isBlackMove)
			var eval = search_moves(isBlackMove, new_possible_moves, depth - 1, alpha, beta)
			min_eval = min(min_eval, eval[0])
			beta = min(beta, eval[0])
			if beta <= alpha:
				break  # Alpha cut-off
			if eval[0] == min_eval:
				best_move = move
		return [min_eval, best_move]
#
func evaluate_position(isBlackMove, bitboard)-> float:
	var final_score = 0
	var directions = get_all_directions(bitboard)
	for direction in directions:
		var direction_score = evaluate_direction(direction, isBlackMove)
		final_score += direction_score

	return final_score

func evaluate_direction(direction, isBlackMove) -> float:
	var direction_product = 1

	for cell in direction:
		var cell_score = 0
		if cell.is_empty():
			cell_score = 1
		elif cell.top_piece.color == "Black":
			cell_score = cell.top_piece.size * 10
			if not isBlackMove:
				cell_score = -cell_score
		else:
			cell_score = cell.top_piece.size * 10
			if isBlackMove:
				cell_score = -cell_score

		# Multiply the cell score with the current product
		direction_product *= cell_score

	return direction_product

func get_all_directions(bitboard):
	var directions = []

	# Add all rows
	for i in range(4):
		directions.append(bitboard[i])

	# Add all columns
	for i in range(4):
		var column = []
		for j in range(4):
			column.append(bitboard[j][i])
		directions.append(column)

	# Add diagonal (top-left to bottom-right)
	var diagonal1 = []
	for i in range(4):
		diagonal1.append(bitboard[i][i])
	directions.append(diagonal1)

	# Add diagonal (top-right to bottom-left)
	var diagonal2 = []
	for i in range(4):
		diagonal2.append(bitboard[i][3 - i])
	directions.append(diagonal2)

	return directions
