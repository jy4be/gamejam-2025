extends IEffect
class_name EffectBlume

var highlight:Array[Vector2i] = []
var neighbors:Array[Vector2i] = []

func intern_onStart(primaryTile : Vector2i, secondaryTile : Vector2i) -> Array[Vector2i]:
	neighbors = Map.getNeighbors(primaryTile,1)
	for n in neighbors:
		highlight.append_array(Map.findTilesAlongRay(primaryTile, n, true))
	for h:Vector2i in highlight:
		Map.getTile(h).setStateFlag(Tile.TILE_STATE.EFFECT_PREVIEW_TARGET, true)
	return highlight

func onSelection(selectedTile : Vector2i):
	for tile:Tile in highlight.map(Map.getTile): 
		tile.effectAnimationDamage.play("default")
		if tile:
			tile.setStateFlag(Tile.TILE_STATE.EFFECT_PREVIEW_TARGET,false)
			var unit:Unit = Map.getUnitOnTile(tile.index)
			if unit:
				unit.health -= 1
	onEnd()
	
func onHighlight(tileUnderMouse : Vector2i):
	pass
	
func getSpritePath()->String:
	return "res://Assets/tiles/Blumenangriff.png"

func getSpritePathBackGround()->String:
	return "res://Assets/tiles/Kirschagon.png"

func isTeamEffect() -> bool:
	return false
	
func getName() -> String:
	return "Blume"
	
func getFlavorText() -> String:
	return """Flower Attack
When this effect is activated, +1 damage is inflicted in all directions (starting from the second activated tile).
"""
