extends CanvasLayer

var stats = []
var visible = false


func add_stat(label: String, caller: Node, target: NodePath, call_method: String = "", args: Array = []) -> void:
    if target.is_empty():
        stats.append([label, caller, "", call_method, args])
    else:
        var target_node = caller.get_node(target)
        var property_path = ":" + target.get_concatenated_subnames()
        stats.append([label, target_node, property_path, call_method, args])


func format_label(label, value):
    return "{0}: {1}\n".format([label, value])


func process_stat(rule) -> String:
    var label = rule[0]
    var node = rule[1]

    if node and weakref(node).get_ref():
        if rule[2] != "":
            var property = node.get_indexed(rule[2])
            if rule[3] == "":
                return format_label(label, property)
        return format_label(label, node.callv(rule[3], rule[4]))

    return ""


func _process(delta):
    if visible:
        var label_text = ""

        label_text += format_label("FPS", Engine.get_frames_per_second())
        label_text += format_label("Static Memory", String.humanize_size( OS.get_static_memory_usage()))

        for stat in stats:
            label_text += process_stat(stat)

        $Label.text = label_text
    else:
        $Label.text = ""
