extends Node
class_name Bitboard
var white_pieces = [0,0,0,0]
var black_pieces = [0,0,0,0]

func _init():
	print("Hello Bitboard")

func get_white_board():
	var ans = 0
	for i in range(4):
		ans |= white_pieces[i]
	return ans

