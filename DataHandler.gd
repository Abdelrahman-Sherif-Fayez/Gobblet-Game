extends Node

var assets := []
enum PieceNames {BLACK_25, BLACK_50, BLACK_75,BLACK_100, WHITE_25, WHITE_50, WHITE_75, WHITE_100}

enum tile_states {NONE, FREE, SELECTED}
# Called when the node enters the scene tree for the first time.
func _ready():
	assets.append("res://art/black_25px.svg")
	assets.append("res://art/black_50px.svg")
	assets.append("res://art/black_75px.svg")
	assets.append("res://art/black_100px.svg")
	assets.append("res://art/white_25px.svg")
	assets.append("res://art/white_50px.svg")
	assets.append("res://art/white_75px.svg")
	assets.append("res://art/white_100px.svg")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
