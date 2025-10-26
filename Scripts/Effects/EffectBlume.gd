extends IEffect
class_name EffectBlume

var highlight:Array[Vector2i] = []
var neighbors:Array[Vector2i] = []

func intern_onStart(primaryTile : Vector2i, secondaryTile : Vector2i) -> Array[Vector2i]:
	neighbors = GlobalVariables.map.getNeighbors(primaryTile,1)
	for n in neighbors:
		highlight.append_array(GlobalVariables.map.findTilesAlongRay(primaryTile, n, true))
	for h:Vector2i in highlight:
		GlobalVariables.map.getTile(h).setStateFlag(Tile.TILE_STATE.EFFECT_PREVIEW_TARGET, true)
	return highlight

func onSelection(selectedTile : Vector2i):
	for tile:Tile in highlight.map(GlobalVariables.map.getTile): 
		tile.effectAnimationDamage.play("default")
		if tile:
			tile.setStateFlag(Tile.TILE_STATE.EFFECT_PREVIEW_TARGET,false)
			var unit:Unit = getUnitOnTile(GlobalVariables.map.getIndexOfTile(tile))
			if unit:
				unit.health -= 1
	onEnd()
	
func onHighlight(tileUnderMouse : Vector2i):
	pass
	
func getSpritePath()->String:
	return "res://Assets/Blumenangriff.png"

func getSpritePathBackGround()->String:
	return "res://Assets/Kirschagon.png"

func isTeamEffect() -> bool:
	return false
	
func getName() -> String:
	return "Blume"
	
func getFlavorText() -> String:
	return """Flower Attack
When this effect is activated, +1 damage is inflicted in all directions (starting from the second activated tile).
"""
