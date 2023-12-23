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

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
