extends Node

var bitboard

func set_board(bitboardGame):
	bitboard = bitboardGame

func play_next_move():
	pass
#will use search moves function and use make move function
#will update the bitboard with the move 

func search_moves(isBlackMove, depth, alpha, beta):
	pass
#will use generate move set fuction recursively and will prune and use eval function 
#to select best move acc to prunning

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
