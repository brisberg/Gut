class_name GutHelper

#var gut_utils_ = load('res://addons/gut/utils.gd').get_instance()

var gut_metadata = {
	path = '',
	subpath = '',
	stubber = null,
	spy = null,
	gut = null,
	from_singleton = '',
	is_partial = false,
}

var _parent = null
func _init(p):
	_parent = p

func set_gut_id(id):
	gut_metadata.gut = gut_instance_from_id(id)


func set_spy_id(id):
	gut_metadata.spy = gut_instance_from_id(id)


func set_stubber_id(id):
	gut_metadata.stubber = gut_instance_from_id(id)


func gut_instance_from_id(inst_id):
	if(inst_id ==  -1):
		return null
	else:
		return instance_from_id(inst_id)


func should_call_super(method_name, called_with):
	if(gut_metadata.stubber != null):
		return gut_metadata.stubber.should_call_super(_parent, method_name, called_with)
	else:
		return false


func spy_on(method_name, called_with):
	if(gut_metadata.spy != null):
		gut_metadata.spy.add_call(_parent, method_name, called_with)


func get_stubbed_return(method_name, called_with):
	if(gut_metadata.stubber != null):
		return gut_metadata.stubber.get_return(_parent, method_name, called_with)
	else:
		return null


func get_default_val(method_name, p_index):
	if(gut_metadata.stubber != null):
		print('getting default')
		return gut_metadata.stubber.get_default_value(_parent, method_name, p_index)
	else:
		print('stubber not set')
		return null


func gut_init():
	if(gut_metadata.gut != null):
		gut_metadata.gut.get_autofree().add_free(_parent)


func get_source_path():
	return gut_metadata.path


func get_source_subpath():
	return gut_metadata.subpath


func get_stubber_key():
	var to_return = gut_metadata.path

	if(gut_metadata.from_singleton != ''):
		to_return = str(gut_metadata.from_singleton)
	elif(gut_metadata.subpath != ''):
		to_return += str('-', gut_metadata.subpath)

	return to_return

func is_partial_double():
	return gut_metadata.is_partial
