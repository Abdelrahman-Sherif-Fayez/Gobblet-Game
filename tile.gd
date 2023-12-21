extends Sprite2D

signal tile_clicked(tile)

@onready var filter_path = $Filter
var tile_ID := -1
var state = DataHandler.tile_states.NONE
var pieces_array = [] # An array for each tile to track pieces on it

func _ready():
	pass

func _process(delta):
	pass

func set_filter(color = DataHandler.tile_states.NONE):
	state = color
	match color:
		DataHandler.tile_states.NONE:
			filter_path.color = Color(0,0,0,0)
		DataHandler.tile_states.FREE:
			filter_path.color = Color(0,1,0,0.4)
		DataHandler.tile_states.SELECTED:
			filter_path.color = Color(0,1,1,0.4)

func _on_filter_gui_input(event: InputEvent):
	if event.is_action_pressed("mouse_left"):
		emit_signal("tile_clicked", self)
