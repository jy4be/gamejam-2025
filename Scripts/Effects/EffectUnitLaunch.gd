extends IEffect

class_name EffectUnitLaunch

func intern_onStart(primaryTile : Vector2i, secondaryTile : Vector2i) -> Array[Vector2i]:
	GlobalVariables.map.mapBuffer.filter(
		func(tile: Tile): 
			return GlobalVariables.units.find_custom(func(unit: Unit): 
					return GlobalVariables.map.getTile(unit.currentOccupiedTileIndex) == tile) == -1)
	return []
	
func onSelection(selectedTile : Vector2i):
	Unit.New_Unit(GlobalVariables.currentPlayer, selectedTile, Unit.UNITTYPE.GENERAL)
	GlobalVariables.currentPlayer.generalsToPlace -= 1
	
func onHighlight(tileUnderMouse : Vector2i):
	pass

func getSpritePath()->String:
	return "res://Assets/Sandagon.png"

func isTeamEffect() -> bool:
	return false
