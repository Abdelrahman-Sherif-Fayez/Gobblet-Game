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

func evaluate_position(isBlackMove, bitboardToEval):
	pass
#Make up your heuristic function
# Very imp ...... No pressure

