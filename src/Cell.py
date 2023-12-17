class Cell:
    def __init__(self, pieces=None):
        if pieces is None:
            pieces = []
        self.pieces = pieces
