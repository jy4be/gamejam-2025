
extends IEffect
class_name EffectDummy
func intern_onStart(primaryTile : Vector2i, secondaryTile : Vector2i) -> Array[Vector2i]:
	onEnd()
	return []

func onSelection(selectedTile : Vector2i):
	pass
	
func onHighlight(tileUnderMouse : Vector2i):
	pass
	
func getSpritePath()->String:
	return "res://Assets/Sandagon.png"
	
func getSpritePathBackGround()->String:
	return "res://Assets/Sandagon.png"

func isTeamEffect() -> bool:
	return false
	
	
func getName() -> String:
	return "Dummy"
