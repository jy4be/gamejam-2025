@abstract class_name IEffect extends Object

var pTile: Vector2i
var sTile: Vector2i

# returns Array<Vector2i> 
func onStart(primaryTile : Vector2i, secondaryTile : Vector2i) -> Array[Vector2i]:
	pTile = primaryTile
	sTile = secondaryTile
	if !isTeamEffect() || getUnitOnTile(primaryTile).controller == getUnitOnTile(secondaryTile).controller :
		
		return intern_onStart(primaryTile,secondaryTile)
	return []
	
@abstract func intern_onStart(primaryTile : Vector2i, secondaryTile : Vector2i) -> Array[Vector2i]
@abstract func onSelection(selectedTile : Vector2i)
@abstract func onHighlight(tileUnderMouse : Vector2i)

@abstract func isTeamEffect() -> bool
@abstract func getSpritePath()->String
@abstract func getSpritePathBackGround()->String
@abstract func getName()->String
@abstract func getFlavorText() -> String

func onEnd() -> void:
	if pTile != Vector2i(-1, -1):
		GlobalVariables.map.getTile(pTile).setStateFlag(Tile.TILE_STATE.ALREADY_TRIGGERED, true)
	if sTile != Vector2i(-1, -1):
		GlobalVariables.map.getTile(sTile).setStateFlag(Tile.TILE_STATE.ALREADY_TRIGGERED, true)

static func getUnitOnTile(tileIndex : Vector2i) -> Unit:
	var index = GlobalVariables.units.find_custom(func (unit : Unit): 
			return unit.currentOccupiedTileIndex == tileIndex)
	if index != -1 :
		return GlobalVariables.units[index]
	return null
