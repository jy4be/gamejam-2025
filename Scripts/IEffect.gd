@abstract class_name IEffect extends Object

var pTile: Vector2i
var sTile: Vector2i

# returns Array<Vector2i> 
func onStart(primaryTile : Vector2i, secondaryTile : Vector2i) -> Array[Vector2i]:
	pTile = primaryTile
	sTile = secondaryTile
	if !isTeamEffect() or\
		Map.getUnitOnTile(primaryTile).controller ==\
		 Map.getUnitOnTile(secondaryTile).controller\
	:
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
		Map.getTile(pTile).setStateFlag(Tile.TILE_STATE.ALREADY_TRIGGERED, true)
	if sTile != Vector2i(-1, -1):
		Map.getTile(sTile).setStateFlag(Tile.TILE_STATE.ALREADY_TRIGGERED, true)
	
class EffectResponse:
	var selectableTiles: Array[Vector2i]
	var needsSelection: bool
