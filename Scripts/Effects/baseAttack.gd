extends IEffect
class_name EffectBaseAttack
func intern_onStart(primaryTile : Vector2i, secondaryTile : Vector2i) -> Array[Vector2i]:
	return GlobalVariables.map.getNeighbors(primaryTile,2)

func onSelection(selectedTile : Vector2i):
	var unit:Unit = getUnitOnTile(selectedTile)
	if unit:
		unit.health -= 1
	
func onHighlight(tileUnderMouse : Vector2i):
	pass
	
func getSpritePath()->String:
	return "res://Assets/baseAttack_tile.png"

func getSpritePathBackGround()->String:
	return "res://Assets/Kirschagon.png"

func isTeamEffect() -> bool:
	return true
	
	
func getName() -> String:
	return "BaseAttack"
