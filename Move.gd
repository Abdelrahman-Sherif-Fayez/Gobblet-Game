extends Node

class_name Move
var from_: int
var stack_no: int # a varibale passed if needed and takes values 0 , 1 , 2 to determine which stack if from_ == -1 or value -1 if not
var to: int
var size: int
var isblack: bool

func _init(a, b,stack_no, size, isblack):
	from_ = a
	to = b
	self.stack_no = stack_no
	self.size = size
	self.isblack = isblack
