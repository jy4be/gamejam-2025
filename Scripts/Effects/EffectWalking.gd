extends IEffect

class_name EffectWalking

const walkingDistance = 2
var currentUnit : Unit = null

func intern_onStart(primaryTile : Vector2i, secondaryTile : Vector2i) -> Array[Vector2i]:
	var index = GlobalVariables.units.find_custom(func (unit : Unit): 
		return unit.currentOccupiedTileIndex == primaryTile and\
			!unit.hasMoved and\
			unit.controller == GlobalVariables.currentPlayer)
	if index == -1 :
		return []
	currentUnit = GlobalVariables.units[index]
	if currentUnit.controller.ActionPoints == 0:
		return []
	currentUnit.animPlayer.play("moveLift")
	var result =  GlobalVariables.map.getNeighbors(primaryTile, currentUnit.controller.ActionPoints).filter(
		func(tile: Vector2i): 
			return GlobalVariables.units.find_custom(func(unit: Unit): 
					return unit.currentOccupiedTileIndex == tile) == -1)
	result.append(primaryTile)
	return result

func onSelection(selectedTile : Vector2i):
	if selectedTile == currentUnit.currentOccupiedTileIndex:
		return
	currentUnit.controller.ActionPoints -= GlobalVariables.map.getDistance(
		currentUnit.currentOccupiedTileIndex,
		selectedTile)
	#GlobalVariables.map.getTile(currentUnit.currentOccupiedTileIndex).setStateFlag(Tile.TILE_STATE.FLIPPED,false)
	GlobalVariables.map.getTile(currentUnit.currentOccupiedTileIndex).flip(false)
	currentUnit.currentOccupiedTileIndex = selectedTile
	#GlobalVariables.map.getTile(currentUnit.currentOccupiedTileIndex).setStateFlag(Tile.TILE_STATE.FLIPPED,true)
	GlobalVariables.map.getTile(currentUnit.currentOccupiedTileIndex).flip(true)
	currentUnit.hasMoved = true
	
func onHighlight(tileUnderMouse : Vector2i):
	pass
	
func getSpritePath()->String:
	return ""

func getSpritePathBackGround()->String:
	return ""

func isTeamEffect() -> bool:
	return false
	
	
func getName() -> String:
	return "Walking"

func getFlavorText() -> String:
	return getName()
