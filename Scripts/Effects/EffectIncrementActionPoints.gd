
extends IEffect
class_name EffectIncrementActionPoints
func intern_onStart(primaryTile : Vector2i, secondaryTile : Vector2i) -> Array[Vector2i]:
	getUnitOnTile(primaryTile).controller.ActionPoints += 1
	onEnd()
	return []

func onSelection(selectedTile : Vector2i):
	pass
	
func onHighlight(tileUnderMouse : Vector2i):
	pass
	
func getSpritePath()->String:
	return "res://Assets/Action_1.png"
	
func getSpritePathBackGround()->String:
	return "res://Assets/Sandagon.png"

func isTeamEffect() -> bool:
	return true

	
func getName() -> String:
	return "IncrementActionPoint"
