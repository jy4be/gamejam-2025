
extends IEffect
class_name EffectShot

var origin:Vector2i = Vector2i(-1,-1)
var highlight:Array[Vector2i] = []

func intern_onStart(primaryTile : Vector2i, secondaryTile : Vector2i) -> Array[Vector2i]:
	origin = primaryTile
	return Map.getNeighbors(primaryTile)

func onSelection(selectedTile : Vector2i):
	for tile:Tile in highlight.map(Map.getTile): 
		if tile:
			tile.setStateFlag(Tile.TILE_STATE.EFFECT_PREVIEW_TARGET,false)
			tile.effectAnimationDamage.play("default")
			var unit:Unit = Map.getUnitOnTile(tile.index)
			if unit:
				unit.health -= 1
	onEnd()
	
func onHighlight(tileUnderMouse : Vector2i):
	for tile:Tile in highlight.map(Map.getTile): 
		if tile:
			tile.setStateFlag(Tile.TILE_STATE.EFFECT_PREVIEW_TARGET,false)
	if tileUnderMouse not in Map.getNeighbors(origin):
		return
	highlight = Map.findTilesAlongRay(origin, tileUnderMouse, true)
	for tile:Tile in highlight.map(Map.getTile): 
		if tile:
			tile.setStateFlag(Tile.TILE_STATE.EFFECT_PREVIEW_TARGET,true)
	
func getSpritePath()->String:
	return "res://Assets/tiles/Scharfschuss.png"
	
func getSpritePathBackGround()->String:
	return "res://Assets/tiles/Kirschagon.png"

func isTeamEffect() -> bool:
	return true
	
func getName()->String:
	return "EffectShot"

func getFlavorText() -> String:
	return """Sniper Shot
When this effect is activated, +1 damage is inflicted in a line (starting from the second activated tile). 
(Team effect)"""
