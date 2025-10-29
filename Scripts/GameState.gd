extends Node

var units: Array[Unit]
var players: Array[Player]
var currentPlayer: Player

enum GAME_STATE {
	NORMAL,
	EFFECT,
	LAUNCH}
var currentEffect: IEffect = null
var selectableTiles: Array[Vector2i] = []
var currentState: GAME_STATE

func initializeGame(playerList: Array, mapReferenceTile: Node2D) -> void:
	Map.referenceTile = mapReferenceTile
	Map.generate(5)
	currentState = GAME_STATE.LAUNCH
	units = []
	players.assign(playerList)
	currentPlayer = playerList[0]
	
	for tile: Tile in Map.mapBuffer.filter(func(t): return t):
		selectableTiles.append(tile.index)
		tile.setStateFlag(Tile.TILE_STATE.SELECTABLE, true)
		
func toNormalState() -> void:
	for t:Tile in Map.mapBuffer.filter(func(t): return t):
		t.setStateFlag(Tile.TILE_STATE.SELECTABLE, false);
	selectableTiles.assign(
		units
		.filter(func(u:Unit):
			return u.controller == currentPlayer and\
				   not u.hasMoved)
		.map(func(u:Unit):
			return u.currentOccupiedTileIndex))
	
	setTileArrayFlag(
		selectableTiles, 
		Tile.TILE_STATE.SELECTABLE, 
		true)
	currentState = GAME_STATE.NORMAL
	
func stateLaunch(selectedTileIndex: Vector2i) -> void:
	Unit.New_Unit(
		currentPlayer, 
		selectedTileIndex, 
		Unit.UNITTYPE.GENERAL)
	currentPlayer.generalsToPlace -= 1
	GlobalVariables.sfxPlayer.stream = load("res://Assets/Heal.wav")
	GlobalVariables.sfxPlayer.play()
	Map\
		.getTile(selectedTileIndex)\
		.setStateFlag(Tile.TILE_STATE.SELECTABLE, false)
	selectableTiles.remove_at(
		selectableTiles.find(selectedTileIndex))
	var currentPlayerIndex: int = players.find(currentPlayer)
	currentPlayer = players[
		(currentPlayerIndex + 1) % len(players)]
	if players.find_custom(
		func(p: Player): 
			return p.generalsToPlace > 0) == -1\
	:
		toNormalState()

func stateNormal(selectedTileIndex: Vector2i) -> void:
	setTileArrayFlag(
		selectableTiles, 
		Tile.TILE_STATE.SELECTABLE, 
		false)
	currentEffect = EffectWalking.new()
	selectableTiles = currentEffect.onStart(
		selectedTileIndex, 
		Vector2i(-1, -1))
	if !selectableTiles.is_empty():
		currentState = GAME_STATE.EFFECT
		setTileArrayFlag(
			selectableTiles, 
			Tile.TILE_STATE.SELECTABLE, 
			true)
			
func stateEffect(selectedTileIndex: Vector2i) -> void:
	currentEffect.onSelection(selectedTileIndex)
	var openPair: Array[Vector2i] = getDuplicateTile(selectedTileIndex, Map.mapBuffer)
	if openPair.is_empty():
		toNormalState()
		return

	setTileArrayFlag(
		selectableTiles, 
		Tile.TILE_STATE.SELECTABLE, 
		false)
	currentEffect = Map.getTile(openPair[0]).tileEffect
	var secondaryTile: Vector2i = openPair[
		(openPair.find(selectedTileIndex) + 1) % 2]
	selectableTiles =\
		currentEffect.onStart(selectedTileIndex, secondaryTile)
	setTileArrayFlag(
		selectableTiles, 
		Tile.TILE_STATE.SELECTABLE, 
		true)
	if selectableTiles.is_empty():
		toNormalState()
		
func updateGameState(selectedTileIndex: Vector2i) -> void:
	if selectedTileIndex not in selectableTiles:
		return
	match currentState:
		GAME_STATE.LAUNCH: stateLaunch(selectedTileIndex)
		GAME_STATE.NORMAL: stateNormal(selectedTileIndex)
		GAME_STATE.EFFECT: stateEffect(selectedTileIndex)

func newHoverIndex(TileIndex: Vector2i):
	if currentEffect && currentState == GAME_STATE.EFFECT:
		currentEffect.onHighlight(TileIndex)

func setTileArrayFlag(tiles: Array[Vector2i], flag:Tile.TILE_STATE, value: bool):
	for tile in tiles:
		Map.getTile(tile).setStateFlag(flag, value)

func endTurn() -> void:
	if currentState != GAME_STATE.NORMAL:
		return
	for unit in units:
		unit.turnReset()
	for player in players:
		player.turnReset()
		
	var currentPlayerIndex: int = players.find(currentPlayer)
	currentPlayer = players[
		(currentPlayerIndex + 1) % len(players)]
	toNormalState()
	
func getDuplicateTile(tile: Vector2i, tiles: Array[Tile]) -> Array[Vector2i]:
	var flipped: Array[Tile] = tiles.filter(func(t:Tile):
		return t and\
			   t.isStateFlag(Tile.TILE_STATE.FLIPPED) and\
			   !t.isStateFlag(Tile.TILE_STATE.ALREADY_TRIGGERED))
		
	var tilesWithSameEffect: Array[Tile] = flipped.filter(
		func(t:Tile): 
			return\
				t.tileEffect.getName() ==\
				Map.getTile(tile).tileEffect.getName())
	var tilesWithSameEffectAndSameTeam: Array[Tile] =\
		tilesWithSameEffect.filter(
			func(t:Tile):
				return Map.getUnitOnTile(t.index).controller ==\
					   Map.getUnitOnTile(tile).controller)
	if tilesWithSameEffectAndSameTeam.size() >= 2:
		return [
			tilesWithSameEffectAndSameTeam[0].index,
			tilesWithSameEffectAndSameTeam[1].index]
	if tilesWithSameEffect.size() >= 2:
		return [
			tilesWithSameEffect[0].index,
			tilesWithSameEffect[1].index]
	return []
