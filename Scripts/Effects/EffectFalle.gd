extends IEffect
class_name EffectFalle
func intern_onStart(primaryTile : Vector2i, secondaryTile : Vector2i) -> Array[Vector2i]:
	for tileIndex in [primaryTile, secondaryTile]:
		var index = GlobalVariables.units.find_custom(func (unit : Unit): 
			return unit.currentOccupiedTileIndex == tileIndex && !unit.hasMoved)
		if index != -1 :
			GlobalVariables.units[index].health -= 1
	onEnd()
	return []

func onSelection(selectedTile : Vector2i):
	pass
	
func onHighlight(tileUnderMouse : Vector2i):
	pass
	
func getSpritePath()->String:
	return "res://Assets/Falle.png"

func getSpritePathBackGround()->String:
	return "res://Assets/Grasagon.png"

func isTeamEffect() -> bool:
	return false

func getName() -> String:
	return "Falle"

func getFlavorText() -> String:
	return getName()
