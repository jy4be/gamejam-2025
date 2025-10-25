extends IEffect
class_name EffectBlume
func intern_onStart(primaryTile : Vector2i, secondaryTile : Vector2i) -> Array[Vector2i]:
	return []

func onSelection(selectedTile : Vector2i):
	pass
	
func onHighlight(tileUnderMouse : Vector2i):
	pass
	
func getSpritePath()->String:
	return "res://Assets/Blume.png"

func isTeamEffect() -> bool:
	return false
