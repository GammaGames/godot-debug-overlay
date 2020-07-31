extends Node2D

var _sprites := []
var _to_remove: int
onready var _sprite: Sprite = $Sprite


func _ready():
    var debug_overlay: DebugOverlay = $Camera2D/DebugOverlay
    debug_overlay.visible = true
    # Add a property stat
    var __ := debug_overlay.add_monitor("Cursor X", self, "Sprite:global_position:x")
    # Add a function (from "self") stat
    __ = debug_overlay.add_monitor("Sprites", self, "", "get_sprite_count")
    # Add a function (from "self") stat with arguments
    _to_remove = debug_overlay.add_monitor("Text", self, "", "get_debug_text", ["This is a test!"])
    print(_to_remove)


func _input(event):
    if event is InputEventMouseMotion:
        _sprite.global_position = get_global_mouse_position()
    if event is InputEventMouseButton and event.pressed:
        var new_sprite = _sprite.duplicate()
        _sprites.append(new_sprite)
        $"/root".add_child(new_sprite)
        new_sprite.visible = true
        new_sprite.global_position = get_global_mouse_position()
        var __ := ($Camera2D/DebugOverlay as DebugOverlay).remove_monitor(_to_remove)


func get_sprite_count():
    return _sprites.size()


func get_debug_text(message):
    return "debug - {0}".format([message])
