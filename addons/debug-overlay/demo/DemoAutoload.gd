extends Node2D

onready var sprite = $Sprite
var sprites = []
var to_remove: int


func _ready():
    DebugOverlay.visible = true
    # Add a property stat
    DebugOverlay.add_monitor()
    DebugOverlay.add_monitor("Cursor X", self, "Sprite:global_position:x")
    # Add a function (from "self") stat
    DebugOverlay.add_monitor("Sprites", self, "", "get_sprite_count")
    # Add a function (from "self") stat with arguments
    to_remove = DebugOverlay.add_monitor("Text", self, "", "get_debug_text", ["This is a test!"])


func _input(event):
    if event is InputEventMouseMotion:
        sprite.global_position = get_global_mouse_position()
    if event is InputEventMouseButton and event.pressed:
        var new_sprite = sprite.duplicate()
        sprites.append(new_sprite)
        $"/root".add_child(new_sprite)
        new_sprite.visible = true
        new_sprite.global_position = get_global_mouse_position()
        DebugOverlay.remove_monitor(to_remove)


func get_sprite_count():
    return sprites.size()


func get_debug_text(message):
    return "debug - {0}".format([message])
