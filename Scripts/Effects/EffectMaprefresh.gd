
extends IEffect
class_name EffectMaprefresh
func intern_onStart(primaryTile : Vector2i, secondaryTile : Vector2i) -> Array[Vector2i]:
	var children = Map.get_children()
	for child in children:
		var tile = child as Tile
		if tile != null:
			tile.queue_free()
	Map.generate(-1)
	GlobalVariables.sfxPlayer.stream = load("res://Assets/Heal.wav")
	GlobalVariables.sfxPlayer.play()
	onEnd()
	return []

func onSelection(selectedTile : Vector2i):
	pass
	
func onHighlight(tileUnderMouse : Vector2i):
	pass
	
func getSpritePath()->String:
	return "res://Assets/tiles/Maprefresh.png"

func getSpritePathBackGround()->String:
	return "res://Assets/tiles/Sandagon.png"

func isTeamEffect() -> bool:
	return false

	
func getName() -> String:
	return "MapRefresh"

func getFlavorText() -> String:
	return """Map Refresh
When this effect is activated, the entire map is regenerated and used effects are replenished.
"""
