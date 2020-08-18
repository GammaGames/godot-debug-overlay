extends Control
# A simple debug overlay to monitor variables
#
#export var scene: PackedScene = \
#		preload("res://addons/debug-overlay/debug_overlay_template.tscn")
var _monitors := {}
var _monitors_sequence := 0 setget , get_sequence
onready var _overlay_text := $Label as Label


func _process(_delta: float) -> void:
	if visible:
		var label_text := ""

		label_text += _format_label("FPS", Engine.get_frames_per_second())
		label_text += _format_label("Static Memory", String.humanize_size( OS.get_static_memory_usage()))

		for id in _monitors:
			label_text += _process_monitor(_monitors[id])

		_overlay_text.text = label_text


func add_monitor(label: String, caller: Node, target: NodePath,
		 call_method := "", args := []) -> int:
	_monitors_sequence += 1

	if target.is_empty():
		_monitors[_monitors_sequence] = [label, caller, "", call_method, args]
	else:
		var target_node := caller.get_node(target)
		var property_path := ":" + target.get_concatenated_subnames()
		_monitors[_monitors_sequence] = [
			label, target_node, property_path, call_method, args,
		]

	return _monitors_sequence


func remove_monitor(id: int) -> bool:
	return _monitors.erase(id)


func get_sequence() -> int:
	return _monitors_sequence


func _format_label(label, value) -> String:
	return "{0}: {1}\n".format([label, value])


func _process_monitor(monitor: Array) -> String:
	var label: String = monitor[0]
	var node: Node = monitor[1]

	if node and weakref(node).get_ref():
		if monitor[2] != "":
			var property = node.get_indexed(monitor[2])
			if monitor[3] == "":
				return _format_label(label, property)
		return _format_label(label, node.callv(monitor[3], monitor[4]))

	return ""
