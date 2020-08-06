extends CanvasLayer
# A simple debug overlay to monitor variables

export var scene: PackedScene = \
		preload("res://addons/debug-overlay/DebugOverlayTemplate.tscn")
var visible := false setget set_visible, get_visible
var _overlay_text: Label
var _monitors := {}
var _monitors_sequence := 0 setget , get_sequence


func _enter_tree() -> void:
	var debug_overlay_template := scene.instance()
	for child_node in debug_overlay_template.get_children():
		add_child((child_node as Node).duplicate())
	debug_overlay_template.queue_free()
	return


func _ready() -> void:
	_overlay_text = get_node("Label")
	return


func _process(_delta: float) -> void:
	if visible:
		var label_text := ""

		label_text += _format_label("FPS", Engine.get_frames_per_second())
		label_text += _format_label("Static Memory", String.humanize_size( OS.get_static_memory_usage()))

		for id in _monitors:
			label_text += _process_monitor(_monitors[id])

		_overlay_text.text = label_text


func set_visible(value: bool) -> void:
	visible = value
	if not visible:
		_overlay_text.text = ""


func get_visible() -> bool:
	return visible


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
