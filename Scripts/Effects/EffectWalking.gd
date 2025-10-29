extends IEffect

class_name EffectWalking

const walkingDistance = 2
var currentUnit : Unit = null

func intern_onStart(primaryTile : Vector2i, secondaryTile : Vector2i) -> Array[Vector2i]:
	var index = GameState.units.find_custom(func (unit : Unit): 
		return unit.currentOccupiedTileIndex == primaryTile and\
			!unit.hasMoved)
	if index == -1 :
		return []
	currentUnit = GameState.units[index]
	if currentUnit.controller.ActionPoints == 0:
		return []
	GlobalVariables.sfxPlayer.stream = load("res://Assets/blipSelect.wav")
	GlobalVariables.sfxPlayer.play()
	currentUnit.animPlayer.play("moveLift")
	var result = Map.getNeighbors(
		primaryTile, 
		currentUnit.controller.ActionPoints
	).filter(
		func(tile: Vector2i): 
			return GameState.units.find_custom(
				func(unit: Unit): 
					return unit.currentOccupiedTileIndex == tile)\
				== -1)
	result.append(primaryTile)
	return result

func onSelection(selectedTile : Vector2i):
	if selectedTile == currentUnit.currentOccupiedTileIndex:
		currentUnit.animPlayer.play("moveSet")
		return
	currentUnit.controller.ActionPoints -= Map.getDistance(
		currentUnit.currentOccupiedTileIndex,
		selectedTile)
	Map.getTile(currentUnit.currentOccupiedTileIndex).flip(false)
	currentUnit.currentOccupiedTileIndex = selectedTile
	Map.getTile(currentUnit.currentOccupiedTileIndex).flip(true)
	currentUnit.hasMoved = true
	GlobalVariables.sfxPlayer.stream = load("res://Assets/place.wav")
	GlobalVariables.sfxPlayer.play()
	
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
