# godot-debug-overlay
A simple debug overlay singleton based on Gonkee's tutorial: https://youtu.be/8Us2cteHbbo

![preview](preview.png "Preview")

Pretty simple to use. Add the `DebugOverlay.gd` and `DebugOverlay.tscn` files to your `addons/debug-overlay` folder. Add the `DebugOverlay.tscn` scene as a singleton to your project. Add stats to watch like the following:

```python3
    DebugOverlay.visible = true
    # Add a property stat
    DebugOverlay.add_stat("Cursor", self, "Sprite:position")
    # Add a function (from "self") stat
    DebugOverlay.add_stat("Sprites", self, "", "get_sprite_count")
    # Add a function (from "self") stat with arguments
    DebugOverlay.add_stat("Text", self, "", "get_debug_text", ["This is a test!"])
```

Demo can be found in `addons/debug-overlay/Demo.tscn` scene.
