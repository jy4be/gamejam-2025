
extends IEffect
class_name EffectMaprefresh
func intern_onStart(primaryTile : Vector2i, secondaryTile : Vector2i) -> Array[Vector2i]:
	var children = GlobalVariables.map.get_children()
	for child in children:
		var tile = child as Tile
		if tile != null:
			tile.queue_free()
	GlobalVariables.map.generate(-1)
	return []

func onSelection(selectedTile : Vector2i):
	pass
	
func onHighlight(tileUnderMouse : Vector2i):
	pass
	
func getSpritePath()->String:
	return "res://Assets/Sandagon.png"

func isTeamEffect() -> bool:
	return false
