extends IEffect
class_name EffectBogen

const range:int = 2
var origin:Vector2i = Vector2i(-1,-1)
var highlight:Array[Vector2i] = []

func intern_onStart(primaryTile : Vector2i, secondaryTile : Vector2i) -> Array[Vector2i]:
	origin = primaryTile
	return GlobalVariables.map.getNeighbors(primaryTile, range, 2)

func onSelection(selectedTile : Vector2i):
	for tile:Tile in highlight.map(GlobalVariables.map.getTile): 
		if tile:
			tile.setStateFlag(Tile.TILE_STATE.EFFECT_PREVIEW_TARGET,false)
	GlobalVariables.map.getTile(selectedTile).effectAnimationDamage.play("default")
	var unit:Unit = getUnitOnTile(selectedTile)
	if unit:
		unit.health -= 1
	onEnd()
	
func onHighlight(tileUnderMouse : Vector2i):
	for tile:Tile in highlight.map(GlobalVariables.map.getTile): 
		if tile:
			tile.setStateFlag(Tile.TILE_STATE.EFFECT_PREVIEW_TARGET,false)
	if tileUnderMouse not in GlobalVariables.map.getNeighbors(origin, range, 2):
		return
	highlight = [tileUnderMouse]
	for tile:Tile in highlight.map(GlobalVariables.map.getTile): 
		if tile:
			tile.setStateFlag(Tile.TILE_STATE.EFFECT_PREVIEW_TARGET,true)
	pass
	
func getSpritePath()->String:
	return "res://Assets/Bogen (1).png"
	
func getSpritePathBackGround()->String:
	return "res://Assets/Grasagon.png"

func isTeamEffect() -> bool:
	return true
	
	
func getName() -> String:
	return "Bogen"

func getFlavorText() -> String:
	return """Ranged Attack
Starting from the second activated tile, +1 damage can be inflicted on a figure within a radius of 2 steps. 
(Team Effect)"""
