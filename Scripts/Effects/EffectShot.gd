
extends IEffect
class_name EffectShot

var origin:Vector2i = Vector2i(-1,-1)
var highlight:Array[Vector2i] = []

func intern_onStart(primaryTile : Vector2i, secondaryTile : Vector2i) -> Array[Vector2i]:
	origin = primaryTile
	return GlobalVariables.map.getNeighbors(primaryTile)

func onSelection(selectedTile : Vector2i):
	for tile:Tile in highlight.map(GlobalVariables.map.getTile): 
		if tile:
			tile.setStateFlag(Tile.TILE_STATE.EFFECT_PREVIEW_TARGET,false)
			var unit:Unit = getUnitOnTile(GlobalVariables.map.getIndexOfTile(tile))
			if unit:
				unit.health -= 1
	onEnd()
	
func onHighlight(tileUnderMouse : Vector2i):
	for tile:Tile in highlight.map(GlobalVariables.map.getTile): 
		if tile:
			tile.setStateFlag(Tile.TILE_STATE.EFFECT_PREVIEW_TARGET,false)
	if tileUnderMouse not in GlobalVariables.map.getNeighbors(origin):
		return
	highlight = GlobalVariables.map.findTilesAlongRay(origin, tileUnderMouse, true)
	for tile:Tile in highlight.map(GlobalVariables.map.getTile): 
		if tile:
			tile.setStateFlag(Tile.TILE_STATE.EFFECT_PREVIEW_TARGET,true)
	
func getSpritePath()->String:
	return "res://Assets/Scharfschuss.png"
	
func getSpritePathBackGround()->String:
	return "res://Assets/Kirschagon.png"

func isTeamEffect() -> bool:
	return false
func getName()->String:
	return "EffectShot"
