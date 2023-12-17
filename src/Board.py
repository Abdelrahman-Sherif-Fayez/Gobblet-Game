from src.Cell import Cell


class Board:
    def __init__(self, rows, cols):
        self.cells = [[Cell() for _ in range(cols)] for _ in range(rows)]
