extends IEffect

class_name EffectWalking

const walkingDistance = 2
var currentUnit : Unit = null

func intern_onStart(primaryTile : Vector2i, secondaryTile : Vector2i) -> Array[Vector2i]:
	var index = GlobalVariables.units.find_custom(func (unit : Unit): 
		return unit.currentOccupiedTileIndex == primaryTile && !unit.hasMoved)
	if index == -1 :
		return []
	currentUnit = GlobalVariables.units[index]
	if currentUnit.controller.ActionPoints == 0:
		return []
	return GlobalVariables.map.getNeighbors(primaryTile, currentUnit.controller.ActionPoints).filter(
		func(tile: Vector2i): 
			return GlobalVariables.units.find_custom(func(unit: Unit): 
					return unit.currentOccupiedTileIndex == tile) == -1)

func onSelection(selectedTile : Vector2i):
	currentUnit.controller.ActionPoints -= GlobalVariables.map.getDistance(
		currentUnit.currentOccupiedTileIndex,
		selectedTile)
	GlobalVariables.map.getTile(currentUnit.currentOccupiedTileIndex).setStateFlag(Tile.TILE_STATE.FLIPPED,false)
	currentUnit.currentOccupiedTileIndex = selectedTile
	GlobalVariables.map.getTile(currentUnit.currentOccupiedTileIndex).setStateFlag(Tile.TILE_STATE.FLIPPED,true)
	currentUnit.hasMoved = true
	pass
	
func onHighlight(tileUnderMouse : Vector2i):
	pass
	
func getSpritePath()->String:
	return "res://Assets/Heal.png"

func isTeamEffect() -> bool:
	return false
