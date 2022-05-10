class_name GutHelper

var gut_utils_ = load('res://addons/gut/utils.gd').get_instance()

var gut_metadata = {
	path = '{path}',
	subpath = '{subpath}',
	stubber = null, #gut_instance_from_id({stubber_id}),
	spy = null, #gut_instance_from_id({spy_id}),
	gut = null, #gut_instance_from_id({gut_id}),
	from_singleton = '{singleton_name}',
	is_partial = null, #{is_partial}
}


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
		return gut_metadata.stubber.should_call_super(self, method_name, called_with)
	else:
		return false


func spy_on(method_name, called_with):
	if(gut_metadata.spy != null):
		gut_metadata.spy.add_call(self, method_name, called_with)


func get_stubbed_return(method_name, called_with):
	if(gut_metadata.stubber != null):
		return gut_metadata.stubber.get_return(self, method_name, called_with)
	else:
		return null


func get_default_val(method_name, p_index):
	if(gut_metadata.stubber != null):
		return gut_metadata.stubber.get_default_value(self, method_name, p_index)
	else:
		return null


func gut_init():
	if(gut_metadata.gut != null):
		gut_metadata.gut.get_autofree().add_free(self)
