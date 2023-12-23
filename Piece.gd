extends Node2D

signal piece_selected(piece)

@onready var icon = $Icon
var tile_ID = -1
var type : int

func load_icon(piece_name):
	icon.texture = load(DataHandler.assets[piece_name])
	if(piece_name == DataHandler.PieceNames.BLACK_25 || piece_name == DataHandler.PieceNames.WHITE_25):
		icon.size = Vector2(25,25)
	elif(piece_name == DataHandler.PieceNames.BLACK_50 || piece_name == DataHandler.PieceNames.WHITE_50):
		icon.size = Vector2(50,50)
	elif(piece_name == DataHandler.PieceNames.BLACK_75 || piece_name == DataHandler.PieceNames.WHITE_75):
		icon.size = Vector2(75,75)
	elif (piece_name == DataHandler.PieceNames.BLACK_100 || piece_name == DataHandler.PieceNames.WHITE_100):
		icon.size = Vector2(90,90)

func get_size():
	return icon.size

func _on_icon_gui_input(event: InputEvent):
	if event.is_action_pressed("mouse_left"):
		emit_signal("piece_selected", self)
