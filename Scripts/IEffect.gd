@abstract class_name IEffect extends Object

# returns Array<Vector2i> 
@abstract func onStart(primaryTile : Vector2i, secondaryTile : Vector2i) -> Array
@abstract func onSelection(selectedTile : Vector2i)
@abstract func onHighlight(tileUnderMouse : Vector2i)
