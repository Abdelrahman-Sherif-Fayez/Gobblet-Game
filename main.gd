extends Node

func show_finish_message(message):
	$GameStatus.show()
	$GameStatus.text = message
	$"BackgroundMusic".stop()
	$GameFinished.play()

func alternate_turn():
	if $PlayerTurn.text == "Black Turn":
		$PlayerTurn.text = "White Turn"
	else:
		$PlayerTurn.text = "Black Turn"
