
extends IEffect
class_name EffectFireBall

var origin:Vector2i = Vector2i(-1,-1)
var highlight:Array[Vector2i] = []

const minRange = 2
const maxRange = 3

func intern_onStart(primaryTile : Vector2i, secondaryTile : Vector2i) -> Array[Vector2i]:
	origin = primaryTile
	return GlobalVariables.map.getNeighbors(primaryTile,maxRange,minRange)

func onSelection(selectedTile : Vector2i):
	for tile:Tile in highlight.map(GlobalVariables.map.getTile): 
		if tile:
			tile.setStateFlag(Tile.TILE_STATE.EFFECT_PREVIEW_TARGET,false)
			tile.effectAnimationDamage.play("default")
			var unit:Unit = getUnitOnTile(GlobalVariables.map.getIndexOfTile(tile))
			if unit:
				unit.health -= 1
			
	onEnd()
	pass
	
func onHighlight(tileUnderMouse : Vector2i):
	for tile:Tile in highlight.map(GlobalVariables.map.getTile): 
		if tile:
			tile.setStateFlag(Tile.TILE_STATE.EFFECT_PREVIEW_TARGET,false)
	var dist = GlobalVariables.map.getDistance(origin,tileUnderMouse)
	
	if dist >= minRange && dist <= maxRange:
		highlight = GlobalVariables.map.getNeighbors(tileUnderMouse)
		for tile:Tile in highlight.map(GlobalVariables.map.getTile): 
			if tile:
				tile.setStateFlag(Tile.TILE_STATE.EFFECT_PREVIEW_TARGET,true)
	pass
	
func getSpritePath()->String:
	return "res://Assets/Feuerball.png"
	
func getSpritePathBackGround()->String:
	return "res://Assets/Grasagon.png"

func isTeamEffect() -> bool:
	return true
	
	
func getName() -> String:
	return "FireBall"
	
func getFlavorText() -> String:
	return """Fireball
When activated, the player can choose a space within a radius of 3 steps (starting from the second activated tile). +1 damage is inflicted on this tile and the neighbouring tiles. 
(Team Effect)"""
