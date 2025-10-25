@abstract class_name IEffect extends Object

# returns Array<Vector2i> 
func onStart(primaryTile : Vector2i, secondaryTile : Vector2i) -> Array[Vector2i]:
	if !isTeamEffect() || getUnitOnTile(primaryTile).controller == getUnitOnTile(secondaryTile).controller :
		return intern_onStart(primaryTile,secondaryTile)
	return []
	
@abstract func intern_onStart(primaryTile : Vector2i, secondaryTile : Vector2i) -> Array[Vector2i]
@abstract func onSelection(selectedTile : Vector2i)
@abstract func onHighlight(tileUnderMouse : Vector2i)

@abstract func isTeamEffect() -> bool
@abstract func getSpritePath()->String

func getUnitOnTile(tileIndex : Vector2i) -> Unit:
	var index = GlobalVariables.units.find_custom(func (unit : Unit): 
			return unit.currentOccupiedTileIndex == tileIndex && !unit.hasMoved)
	if index != -1 :
		return GlobalVariables.units[index]
	return null
