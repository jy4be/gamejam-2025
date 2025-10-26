
extends IEffect
class_name EffectKettenblitz

var origin:Vector2i = Vector2i(-1,-1)
var highlight:Array[Vector2i] = []
var secondaryTileIndex:Vector2i = Vector2i(-1,-1)

func intern_onStart(primaryTile : Vector2i, secondaryTile : Vector2i) -> Array[Vector2i]:
	secondaryTileIndex = secondaryTile
	highlight.append_array(GlobalVariables.map.findTilesAlongRay(primaryTile, secondaryTile, false))
	for h:Vector2i in highlight:
		GlobalVariables.map.getTile(h).setStateFlag(Tile.TILE_STATE.EFFECT_PREVIEW_TARGET, true)
	return highlight

func onSelection(selectedTile : Vector2i):
	for tile:Tile in highlight.map(GlobalVariables.map.getTile): 
		if tile:
			tile.setStateFlag(Tile.TILE_STATE.EFFECT_PREVIEW_TARGET,false)
			var tileIndex = GlobalVariables.map.getIndexOfTile(tile)
			if tileIndex != origin && tileIndex != secondaryTileIndex:
				var unit:Unit = getUnitOnTile(tileIndex)
				if unit:
					unit.health -= 1
	onEnd()
	
func onHighlight(tileUnderMouse : Vector2i):
	pass

func getSpritePath()->String:
	return "res://Assets/Kettenblitz.png"
	
func getSpritePathBackGround()->String:
	return "res://Assets/Sandagon.png"

func isTeamEffect() -> bool:
	return false
	
func getName()->String:
	return "EffectKettenblitz"

func getFlavorText() -> String:
	return """Chain Lightning
All squares in a line between the two Chain Lightning tiles inflict +1 damage on the figures standing on them.
"""
