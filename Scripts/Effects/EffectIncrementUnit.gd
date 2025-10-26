
extends IEffect
class_name EffectIncrementUnit
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
	Unit.New_Unit(GlobalVariables.currentPlayer, selectedTile, Unit.UNITTYPE.PAWN)
	GlobalVariables.sfxPlayer.stream = load("res://Assets/Heal.wav")
	GlobalVariables.sfxPlayer.play()
	onEnd()
	
func onHighlight(tileUnderMouse : Vector2i):
	pass
	
func getSpritePath()->String:
	return "res://Assets/Figur_1.png"
	
func getSpritePathBackGround()->String:
	return "res://Assets/Sandagon.png"

func isTeamEffect() -> bool:
	return true
	
		
func getName() -> String:
	return "IncrementUnit"

func getFlavorText() -> String:
	return """Figure +1
The player who activates this effect permanently gains +1 figure. 
(Team effect)"""
