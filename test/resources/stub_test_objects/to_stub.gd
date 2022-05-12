# this class is used by test_stubber and represents a doubled object
# which is why we have __gut_helper__.gut_metadata in here.
var value = 4

var __gut_helper__ = GutHelper.new(self)

func __is_gut_double():
	return true


func _init():
	__gut_helper__.gut_metadata.path='res://test/resources/stub_test_objects/to_stub.gd'


func get_value():
	return value

func set_value(val):
	value = val
