extends IEffect
class_name EffectHeal
func intern_onStart(primaryTile : Vector2i, secondaryTile : Vector2i) -> Array[Vector2i]:
	for tileIndex in [primaryTile, secondaryTile]:
		var index = GlobalVariables.units.find_custom(func (unit : Unit): 
			return unit.currentOccupiedTileIndex == tileIndex)
		if index != -1 :
			GlobalVariables.units[index].heal()
	GlobalVariables.sfxPlayer.stream = load("res://Assets/Heal.wav")
	GlobalVariables.sfxPlayer.play()
	onEnd()
	return []

func onSelection(selectedTile : Vector2i):
	pass
	
func onHighlight(tileUnderMouse : Vector2i):
	pass
	
func getSpritePath()->String:
	return "res://Assets/Heal.png"

func getSpritePathBackGround()->String:
	return "res://Assets/Kirschagon.png"

func isTeamEffect() -> bool:
	return false

	
func getName() -> String:
	return "Heal"

func getFlavorText() -> String:
	return """Heal
When this effect is activated, the HP of both figures standing on the healing tiles are replenished to a maximum of 2 HP.
 """
