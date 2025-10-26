
extends IEffect
class_name EffectTeleport
func intern_onStart(primaryTile : Vector2i, secondaryTile : Vector2i) -> Array[Vector2i]:
	var unit1 = getUnitOnTile(primaryTile)
	var unit2 = getUnitOnTile(secondaryTile)
	unit1.currentOccupiedTileIndex = secondaryTile
	unit2.currentOccupiedTileIndex = primaryTile
	unit1.slashAnim.play("Teleport")
	unit2.slashAnim.play("Teleport")
	GlobalVariables.sfxPlayer.stream = load("res://Assets/powerUp.wav")
	GlobalVariables.sfxPlayer.play()
	onEnd()
	return []

func onSelection(selectedTile : Vector2i):
	pass
	
func onHighlight(tileUnderMouse : Vector2i):
	pass
	
func getSpritePath()->String:
	return "res://Assets/Teleport.png"
	
func getSpritePathBackGround()->String:
	return "res://Assets/Grasagon.png"

func isTeamEffect() -> bool:
	return false
	
	
func getName() -> String:
	return "Teleport"

func getFlavorText() -> String:
	return "Teleport
The two figures on the activated teleportation tiles swap places."
