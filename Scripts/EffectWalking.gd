extends IEffect

const walkingDistance = 2
var currentUnit : Unit = null

func onStart(primaryTile : Vector2i, secondaryTile : Vector2i) -> Array:
	var index = GlobalVariables.units.find_custom(func (unit : Unit): return unit.currentOccupiedTileIndex == primaryTile)
	if index == -1 :
		return []
	currentUnit = GlobalVariables.units[index]
	return GlobalVariables.map.getNeighbors(primaryTile, walkingDistance)

func onSelection(selectedTile : Vector2i):
	currentUnit.currentOccupiedTileIndex = selectedTile
	pass
	
func onHighlight(tileUnderMouse : Vector2i):
	pass
