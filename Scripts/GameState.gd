extends Node

class_name GameState

enum GAME_STATE {
	NORMAL,
	EFFECT,
	LAUNCH,
	MAIN_MENU,
	GAME_OVER}
var currentEffect: IEffect = null
var selectableTiles: Array[Vector2i] = []
var currentState: GAME_STATE = GAME_STATE.LAUNCH

func initializeGame() -> void:
	var tiles = GlobalVariables.map.mapBuffer.filter(
		func(t:Tile): 
			return t)
	for tile: Tile in tiles:
		selectableTiles.append(GlobalVariables.map.getIndexOfTile(tile))
		tile.setStateFlag(Tile.TILE_STATE.SELECTABLE, true)
		
func toNormalState() -> void:
	for t:Tile in GlobalVariables.map.mapBuffer:
		if t:
			t.setStateFlag(Tile.TILE_STATE.SELECTABLE, false);
	selectableTiles.assign(GlobalVariables.units\
		.filter(func(u:Unit):return u.controller == GlobalVariables.currentPlayer and not u.hasMoved)\
		.map(func(u:Unit):return u.currentOccupiedTileIndex))
	
	setTileArrayFlag(selectableTiles, Tile.TILE_STATE.SELECTABLE, true)
	currentState = GAME_STATE.NORMAL

func updateGameState(selectedTileIndex: Vector2i) -> void:
	if selectedTileIndex not in selectableTiles:
		return
	match currentState:
		GAME_STATE.LAUNCH:
			Unit.New_Unit(GlobalVariables.currentPlayer, selectedTileIndex, Unit.UNITTYPE.GENERAL)
			GlobalVariables.currentPlayer.generalsToPlace -= 1
			GlobalVariables.sfxPlayer.stream = load("res://Assets/Heal.wav")
			GlobalVariables.sfxPlayer.play()
			GlobalVariables.map.getTile(selectedTileIndex).setStateFlag(Tile.TILE_STATE.SELECTABLE, false)
			selectableTiles.remove_at(selectableTiles.find(selectedTileIndex))
			endTurn()
			if GlobalVariables.players.find_custom(func(p: Player): return p.generalsToPlace > 0) == -1:
				toNormalState()
		GAME_STATE.NORMAL:
			setTileArrayFlag(selectableTiles, Tile.TILE_STATE.SELECTABLE, false)
			currentEffect = EffectWalking.new()
			selectableTiles = currentEffect.onStart(selectedTileIndex, Vector2i(-1, -1))
			if !selectableTiles.is_empty():
				currentState = GAME_STATE.EFFECT
				setTileArrayFlag(selectableTiles, Tile.TILE_STATE.SELECTABLE, true)
		GAME_STATE.EFFECT:
			currentEffect.onSelection(selectedTileIndex)
			var openPair: Array[Vector2i] = getDuplicateTile(selectedTileIndex, GlobalVariables.map.mapBuffer)
			if openPair.is_empty():
				toNormalState()
				return
			setTileArrayFlag(selectableTiles, Tile.TILE_STATE.SELECTABLE, false)
			currentEffect = GlobalVariables.map.getTile(openPair[0]).tileEffect
			var secondaryTile: Vector2i = openPair[openPair.find_custom(func(t:Vector2i): return t != selectedTileIndex)]
			selectableTiles = currentEffect.onStart(selectedTileIndex, secondaryTile)
			setTileArrayFlag(selectableTiles, Tile.TILE_STATE.SELECTABLE, true)
			if selectableTiles.is_empty():
				toNormalState()
				
				
func newHoverIndex(TileIndex: Vector2i):
	if currentEffect && currentState == GAME_STATE.EFFECT:
		currentEffect.onHighlight(TileIndex)

func setTileArrayFlag(tiles: Array[Vector2i], flag:Tile.TILE_STATE, value: bool):
	for tile in tiles:
		GlobalVariables.map.getTile(tile).setStateFlag(flag, value)

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
	
	if currentState == GAME_STATE.NORMAL:
		toNormalState()
	
func getDuplicateTile(tile: Vector2i, tiles: Array[Tile]) -> Array[Vector2i]:
	var flipped: Array[Tile] = tiles.filter(func(t:Tile):
		return t and\
			   t.isStateFlag(Tile.TILE_STATE.FLIPPED) and\
			   !t.isStateFlag(Tile.TILE_STATE.ALREADY_TRIGGERED))
		
	var tilesWithSameEffect: Array[Tile]  = flipped.filter(func(t:Tile): return t.tileEffect.getName() == GlobalVariables.map.getTile(tile).tileEffect.getName())
	var tilesWithSameEffectAndSameTeam: Array[Tile]  = tilesWithSameEffect.filter(func(t:Tile):
		return Map.getUnitOnTile(GlobalVariables.map.getIndexOfTile(t)).controller == Map.getUnitOnTile(tile).controller)
	if tilesWithSameEffectAndSameTeam.size() >= 2:
		return [GlobalVariables.map.getIndexOfTile(tilesWithSameEffectAndSameTeam[0]),
		GlobalVariables.map.getIndexOfTile(tilesWithSameEffectAndSameTeam[1])]
	if tilesWithSameEffect.size() >= 2:
		return [GlobalVariables.map.getIndexOfTile(tilesWithSameEffect[0]),
		GlobalVariables.map.getIndexOfTile(tilesWithSameEffect[1])]
	return []
