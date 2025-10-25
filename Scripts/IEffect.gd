@abstract class_name IEffect extends Object


# returns Array<Vector2i> 
func onStart(primaryTile : Vector2i, secondaryTile : Vector2i) -> Array[Vector2i]:
	if !isTeamEffect() || getUnitOnTile(primaryTile).controller == getUnitOnTile(secondaryTile).controller :
		if primaryTile != Vector2i(-1, -1) && getName() == GlobalVariables.map.getTile(primaryTile).tileEffect.getName():
			GlobalVariables.map.getTile(primaryTile).setStateFlag(Tile.TILE_STATE.ALREADY_TRIGGERED, true)
		if secondaryTile != Vector2i(-1, -1)&& getName() == GlobalVariables.map.getTile(secondaryTile).tileEffect.getName():
			GlobalVariables.map.getTile(secondaryTile).setStateFlag(Tile.TILE_STATE.ALREADY_TRIGGERED, true)
		return intern_onStart(primaryTile,secondaryTile)
	return []
	
@abstract func intern_onStart(primaryTile : Vector2i, secondaryTile : Vector2i) -> Array[Vector2i]
@abstract func onSelection(selectedTile : Vector2i)
@abstract func onHighlight(tileUnderMouse : Vector2i)

@abstract func isTeamEffect() -> bool
@abstract func getSpritePath()->String
@abstract func getSpritePathBackGround()->String
@abstract func getName()->String

static func getUnitOnTile(tileIndex : Vector2i) -> Unit:
	var index = GlobalVariables.units.find_custom(func (unit : Unit): 
			return unit.currentOccupiedTileIndex == tileIndex)
	if index != -1 :
		return GlobalVariables.units[index]
	return null
