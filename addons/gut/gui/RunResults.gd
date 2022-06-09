extends Control
tool

var _interface = null
var _utils = load('res://addons/gut/utils.gd').new()

var ScriptResult = load('res://addons/gut/gui/ScriptResult.tscn')
var TestResult = load('res://addons/gut/gui/TestResult.tscn')




# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
onready var _ctrls = {
	test_result_ctrl = $TestResult,
	script_result_ctrl = $ScriptResult,
	vbox = $Panel/Scroll/VBox
}



func set_interface(which):
	_interface = which


func _ready():
	remove_child(_ctrls.test_result_ctrl)
	remove_child(_ctrls.script_result_ctrl)
	if(get_parent() == get_tree().root):
		load_json_results('user://.gut_editor.json')


func _open_file(path, line_number):
	if(_interface == null):
		print('Too soon, wait a bit and try again.')
		return

	var r = load(path)
	if(line_number != -1):
		_interface.edit_script(r, line_number)
	else:
		_interface.edit_script(r)


func _on_Button_pressed():
	_open_file('res://test/unit/test_print.gd', 27)


func _add_script_ctrl(script_path, script_json):
	var obj = ScriptResult.instance()
	_ctrls.vbox.add_child(obj)
	obj.set_name(script_path)
	var status_text = str(script_json.props.tests - script_json.props.failures , '/',
		script_json.props.tests)
	obj.set_status(status_text)

	return obj


func _add_test_ctrl_to_script_ctrl(test_name, test_json, script_ctrl):
	var obj = TestResult.instance()

	script_ctrl.add_test_result(obj)
	obj.set_name(test_name)
	obj.set_status(test_json.status)
	var line = -1
	if(test_json.failing.size() > 0):
		var f_text = test_json.failing[0]
		line = f_text.split("at line")[-1].split(" ")[-1]
	obj.set_goto(script_ctrl.get_path(), int(line))

	return obj

func _on_test_result_goto(path, line):
	if(_interface):
		_open_file(path, line)
	else:
		print('going to ', path, '@', line)

func load_json_results(path):
	var text = _utils.get_file_as_text('user://.gut_editor.json')
	var j = JSON.parse(text).result

	var scripts = j['test_scripts']['scripts']
	var script_keys = scripts.keys()
	for key in script_keys:
		print(key)
		var tests = scripts[key]['tests']
		var test_keys = tests.keys()
		var script_obj = _add_script_ctrl(key, scripts[key])
		for test_key in test_keys:
			var test_obj = _add_test_ctrl_to_script_ctrl(test_key, tests[test_key], script_obj)
			test_obj.connect('goto', self, '_on_test_result_goto')
			print('  ', tests[test_key].status)
			if(tests[test_key].status == 'fail'):
				for f_text in tests[test_key]["failing"]:
					var line_number = f_text.split("at line")[-1].split(" ")[-1]
					print('  ', line_number)
			else:
				pass


