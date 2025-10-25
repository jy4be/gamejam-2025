extends Node2D

var map: Map
@onready var label: RichTextLabel = $Camera2D/UIComponents/RichTextLabel
@onready var playersNode: Node = $Players

var state: GameState = GameState.new()

var clickedLastFrame: bool = false

var currentHoveredTileIndex: Vector2i = Vector2i(-1, -1)
var selectedTileIndex: Vector2i = Vector2i(-1, -1)

var currentSelectedTileIndexXY: Vector2i = Vector2i(-1,-1)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalVariables.map = $Map
	map = GlobalVariables.map
	enlistPlayers()
	GlobalVariables.currentPlayer = GlobalVariables.players[0]
	map.generate(5)
	SignalBus.connect("MouseTileHover", 
		func(tile: Tile): 
			currentHoveredTileIndex = map.getIndexOfTile(tile)
			state.newHoverIndex(currentHoveredTileIndex)
			tile.setStateFlag(Tile.TILE_STATE.HOVERED, true)
			currentSelectedTileIndexXY = map.getIndexOfTile(tile))

	SignalBus.connect("MouseTileExit", 
		func(tile: Tile):
			tile.setStateFlag(Tile.TILE_STATE.HOVERED, false)
			if tile == map.getTile(currentHoveredTileIndex):
				currentHoveredTileIndex = Vector2i(-1, -1)
			
			)
			
	#Unit.New_Unit(GlobalVariables.currentPlayer, Vector2i(5,5), Unit.UNITTYPE.GENERAL)
	#Unit.New_Unit(GlobalVariables.currentPlayer, Vector2i(4,4), Unit.UNITTYPE.PAWN)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#debug Effects
	if Input.is_key_pressed(KEY_E):
		state.currentEffect = EffectMaprefresh.new()
		state.selectableTiles = state.currentEffect.onStart(selectedTileIndex, Vector2i(-1, -1))
		if !state.selectableTiles.is_empty():
			state.currentState = state.GAME_STATE.EFFECT
			state.setTileArrayFlag(state.selectableTiles, Tile.TILE_STATE.SELECTABLE, true)
	
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) && !clickedLastFrame:
		clickedLastFrame = true
		selectedTileIndex = currentHoveredTileIndex
		state.updateGameState(selectedTileIndex)
		
	elif !Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		clickedLastFrame = false
	if state.currentState == GameState.GAME_STATE.LAUNCH:
		state.updateGameState(selectedTileIndex)

	label.text = "Tile: (%d;%d)\nPlayer AP: %d\n GameState: %s\nCurrentPlayer: %s"%  [
		currentSelectedTileIndexXY.x, currentSelectedTileIndexXY.y, 
		GlobalVariables.currentPlayer.ActionPoints, 
		str(state.currentState),
		GlobalVariables.currentPlayer.PlayerName]
	

			
func enlistPlayers() -> void:
	GlobalVariables.players.append_array(
		playersNode.get_children()
		.map(
			func(n: Node) -> Player: return n))

	
func destroyUnit(unitIndex: int) -> void:
	var unit: Unit = GlobalVariables.units.pop_at(unitIndex)
	unit.queue_free()
	
func _on_end_turn_button_pressed() -> void:
	state.endTurn()
