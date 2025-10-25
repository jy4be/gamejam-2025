extends Node

class_name GameState

enum GAME_STATE {
	NORMAL,
	EFFECT}
var currentEffect: IEffect = null
var selectableTiles: Array[Vector2i] = []
var currentState: GAME_STATE = GAME_STATE.NORMAL
func updateGameState(selectedTileIndex: Vector2i) -> void:
	match currentState:
		GAME_STATE.NORMAL:
			currentEffect = EffectWalking.new()
			selectableTiles = currentEffect.onStart(selectedTileIndex, Vector2i(-1, -1))
			if !selectableTiles.is_empty():
				currentState = GAME_STATE.EFFECT
				setTileArrayFlag(selectableTiles, Tile.TILE_STATE.SELECTABLE, true)
		GAME_STATE.EFFECT:
			if selectedTileIndex in selectableTiles:
				currentEffect.onSelection(selectedTileIndex)
				currentState = GAME_STATE.NORMAL
				setTileArrayFlag(selectableTiles, Tile.TILE_STATE.SELECTABLE, false)
				
func setTileArrayFlag(tiles: Array[Vector2i], flag:Tile.TILE_STATE, value: bool):
	for tile in tiles:
		GlobalVariables.map.getTile(tile).setStateFlag(flag, value)

func endTurn() -> void:
	if currentState != GAME_STATE.NORMAL:
		return
	for unit in GlobalVariables.units:
		unit.turnReset()
	for player in GlobalVariables.players:
		player.turnReset()
		
	var currentPlayerIndex: int = GlobalVariables.players.find(GlobalVariables.currentPlayer)
	GlobalVariables.currentPlayer = GlobalVariables.players[
		(currentPlayerIndex + 1) % len(GlobalVariables.players)]
