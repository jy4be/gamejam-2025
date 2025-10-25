extends IEffect
class_name EffectBogen

const range:int = 2

func intern_onStart(primaryTile : Vector2i, secondaryTile : Vector2i) -> Array[Vector2i]:
	return GlobalVariables.map.getNeighbors(primaryTile, range)

func onSelection(selectedTile : Vector2i):
	var unit:Unit = getUnitOnTile(selectedTile)
	if unit:
		unit.health -= 1
	
func onHighlight(tileUnderMouse : Vector2i):
	pass
	
func getSpritePath()->String:
	return "res://Assets/Bestagon_flip.png" #TODO
	
func getSpritePathBackGround()->String:
	return "res://Assets/Grasagon.png"

func isTeamEffect() -> bool:
	return false
	
	
func getName() -> String:
	return "Bogen"
