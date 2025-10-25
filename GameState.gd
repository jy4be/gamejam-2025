extends Node

class_name GameState

enum GAME_STATE {
	NORMAL,
	EFFECT,
	LAUNCH}
var currentEffect: IEffect = null
var selectableTiles: Array[Vector2i] = []
var currentState: GAME_STATE = GAME_STATE.LAUNCH

func updateGameState(selectedTileIndex: Vector2i) -> void:
	match currentState:
		GAME_STATE.LAUNCH:
			currentEffect = EffectUnitLaunch.new()
			selectableTiles = currentEffect.onStart(Vector2i(-1, -1), Vector2i(-1, -1))
			if !selectableTiles.is_empty():
				currentState = GAME_STATE.EFFECT
				setTileArrayFlag(selectableTiles, Tile.TILE_STATE.SELECTABLE, true)
		GAME_STATE.NORMAL:
			currentEffect = EffectWalking.new()
			selectableTiles = currentEffect.onStart(selectedTileIndex, Vector2i(-1, -1))
			if !selectableTiles.is_empty():
				currentState = GAME_STATE.EFFECT
				setTileArrayFlag(selectableTiles, Tile.TILE_STATE.SELECTABLE, true)
		GAME_STATE.EFFECT:
			if selectedTileIndex in selectableTiles:
				
				currentEffect.onSelection(selectedTileIndex)
				var openPair: Array[Vector2i] = getDuplicateTile(GlobalVariables.map.mapBuffer)
				if !openPair.is_empty():
					
					setTileArrayFlag(selectableTiles, Tile.TILE_STATE.SELECTABLE, false)
					setTileArrayFlag(openPair, Tile.TILE_STATE.ALREADY_TRIGGERED, true)
					currentEffect = GlobalVariables.map.getTile(openPair[0]).tileEffect
					currentState = GAME_STATE.EFFECT
					var secondaryTile: Vector2i = openPair[openPair.find_custom(func(t:Vector2i): return t != selectedTileIndex)]
					selectableTiles = currentEffect.onStart(
						selectedTileIndex,
						secondaryTile)
					
					if !selectableTiles.is_empty():
						setTileArrayFlag(selectableTiles, Tile.TILE_STATE.SELECTABLE, true)
				elif GlobalVariables.players.find_custom(func(p:Player): return p.generalsToPlace > 0) == -1:
					currentState = GAME_STATE.NORMAL
					#setTileArrayFlag(selectableTiles, Tile.TILE_STATE.SELECTABLE, false)
				else:
					currentState = GAME_STATE.LAUNCH
					endTurn()
					#setTileArrayFlag(selectableTiles, Tile.TILE_STATE.SELECTABLE, false)
				
func setTileArrayFlag(tiles: Array[Vector2i], flag:Tile.TILE_STATE, value: bool):
	for tile in tiles:
		GlobalVariables.map.getTile(tile).setStateFlag(flag, value)
		#print(tile)

func endTurn() -> void:
	if currentState == GAME_STATE.EFFECT:
		return
	for unit in GlobalVariables.units:
		unit.turnReset()
	for player in GlobalVariables.players:
		player.turnReset()
		
	var currentPlayerIndex: int = GlobalVariables.players.find(GlobalVariables.currentPlayer)
	GlobalVariables.currentPlayer = GlobalVariables.players[
		(currentPlayerIndex + 1) % len(GlobalVariables.players)]
	
func getDuplicateTile(tiles: Array[Tile]) -> Array[Vector2i]:
	var flipped: Array[Tile] = tiles.filter(func(t:Tile):return t and\
		t.isStateFlag(Tile.TILE_STATE.FLIPPED) and\
		!t.isStateFlag(Tile.TILE_STATE.ALREADY_TRIGGERED))
	for f in flipped:
		var tilesWithSameEffect: Array[Tile] = flipped.filter(func(t:Tile): return t.tileEffect.getName() == f.tileEffect.getName())
		if len(tilesWithSameEffect) > 1:
			print("%s, %s" % [tilesWithSameEffect[0].tileEffect.getName(), tilesWithSameEffect[1].tileEffect.getName()])
			return [GlobalVariables.map.getIndexOfTile(tilesWithSameEffect[0]),
					GlobalVariables.map.getIndexOfTile(tilesWithSameEffect[1])]
	return []
