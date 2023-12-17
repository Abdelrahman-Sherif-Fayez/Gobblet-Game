from src.Board import Board
from src.Piece import Piece


class Game:
    def __init__(self):
        self.current_player = 1
        self.board = Board(rows=4, cols=4)
        self.players_pieces = {1: [], 2: []}

        # Assign three pieces of each size to each player
        for _ in range(3):
            self.players_pieces[1].append(Piece(size=1, color="white"))
            self.players_pieces[1].append(Piece(size=2, color="white"))
            self.players_pieces[1].append(Piece(size=3, color="white"))

            self.players_pieces[2].append(Piece(size=1, color="black"))
            self.players_pieces[2].append(Piece(size=2, color="black"))
            self.players_pieces[2].append(Piece(size=3, color="black"))
