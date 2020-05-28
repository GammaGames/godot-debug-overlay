extends Node2D

onready var sprite = $Sprite
var sprites = []
var to_remove: int


func _ready():
    var debug_overlay = $Camera2D/DebugOverlay
    debug_overlay.visible = true
    # Add a property stat
    debug_overlay.add_monitor("Cursor X", self, "Sprite:global_position:x")
    # Add a function (from "self") stat
    debug_overlay.add_monitor("Sprites", self, "", "get_sprite_count")
    # Add a function (from "self") stat with arguments
    to_remove = debug_overlay.add_monitor("Text", self, "", "get_debug_text", ["This is a test!"])
    print(to_remove)


func _input(event):
    if event is InputEventMouseMotion:
        sprite.global_position = get_global_mouse_position()
    if event is InputEventMouseButton and event.pressed:
        var new_sprite = sprite.duplicate()
        sprites.append(new_sprite)
        $"/root".add_child(new_sprite)
        new_sprite.visible = true
        new_sprite.global_position = get_global_mouse_position()
        $Camera2D/DebugOverlay.remove_monitor(to_remove)


func get_sprite_count():
    return sprites.size()


func get_debug_text(message):
    return "debug - {0}".format([message])
