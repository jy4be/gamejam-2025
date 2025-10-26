extends IEffect

class_name EffectUnitLaunch

func intern_onStart(primaryTile : Vector2i, secondaryTile : Vector2i) -> Array[Vector2i]:
	var toReturn: Array[Vector2i]
	toReturn.assign(GlobalVariables.map.mapBuffer.filter(
		func(tile: Tile): 
			return GlobalVariables.units.find_custom(func(unit: Unit): 
					return GlobalVariables.map.getTile(unit.currentOccupiedTileIndex) == tile) == -1 && tile != null).map(
						func(t:Tile):return GlobalVariables.map.getIndexOfTile(t)
					))
	return toReturn
	
func onSelection(selectedTile : Vector2i):
	Unit.New_Unit(GlobalVariables.currentPlayer, selectedTile, Unit.UNITTYPE.GENERAL)
	GlobalVariables.currentPlayer.generalsToPlace -= 1
	#onEnd()
	
func onHighlight(tileUnderMouse : Vector2i):
	pass

func getSpritePath()->String:
	return ""

func getSpritePathBackGround()->String:
	return ""

func isTeamEffect() -> bool:
	return false
	
	
func getName() -> String:
	return "UnitLaunch"

func getFlavorText() -> String:
	return getName()
