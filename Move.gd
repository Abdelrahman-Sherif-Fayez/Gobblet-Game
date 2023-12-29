extends Node

class_name Move
var from_: int
var to: int
var size: int
var isblack: bool

func _init(a, b, size, isblack):
	from_ = a
	to = b
	self.size = size
	self.isblack = isblack
