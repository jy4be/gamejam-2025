extends Node2D

var map: Map
@onready var label: RichTextLabel = $UIComponents/RichTextLabel
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
	map.generate(Vector2i(10, 10))
	SignalBus.connect("MouseTileHover", 
		func(tile: Tile): 
			currentHoveredTileIndex = map.getIndexOfTile(tile)
			tile.setStateFlag(Tile.TILE_STATE.HOVERED, true)
			currentSelectedTileIndexXY = map.getIndexOfTile(tile))

	SignalBus.connect("MouseTileExit", 
		func(tile: Tile):
			if tile == map.getTile(currentHoveredTileIndex):
				currentHoveredTileIndex = Vector2i(-1, -1)
			tile.setStateFlag(Tile.TILE_STATE.HOVERED, false))
			
	#Unit.New_Unit(GlobalVariables.currentPlayer, Vector2i(5,5), Unit.UNITTYPE.GENERAL)
	#Unit.New_Unit(GlobalVariables.currentPlayer, Vector2i(4,4), Unit.UNITTYPE.PAWN)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) && !clickedLastFrame:
		clickedLastFrame = true
		state.updateGameState(selectedTileIndex)
	elif !Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		clickedLastFrame = false
	setSelection()

	label.text = "Tile: (%d;%d)\nPlayer AP: %d\n GameState: %s" %  [
		currentSelectedTileIndexXY.x, currentSelectedTileIndexXY.y, 
		GlobalVariables.currentPlayer.ActionPoints, 
		str(state.currentState)]
					
func setSelection():
	if selectedTileIndex != Vector2i(-1, -1):
		map.getTile(selectedTileIndex).setStateFlag(Tile.TILE_STATE.SELECTED, false)
	if currentHoveredTileIndex != Vector2i(-1, -1):
		map.getTile(currentHoveredTileIndex).setStateFlag(Tile.TILE_STATE.SELECTED, true)
	selectedTileIndex = currentHoveredTileIndex

			
func enlistPlayers() -> void:
	GlobalVariables.players.append_array(
		playersNode.get_children()
		.map(
			func(n: Node) -> Player: return n))
	
#func createUnit(unitScene: Resource, owningPlayer: Player, tileIndex: Vector2i, type: Unit.UNITTYPE) -> void:
	#var unit:Unit = Unit.New_Unit(GlobalVariables.currentPlayer, tileIndex, type)
	#add_child(unit)
	#GlobalVariables.units.append(unit)
	
func destroyUnit(unitIndex: int) -> void:
	var unit: Unit = GlobalVariables.units.pop_at(unitIndex)
	unit.queue_free()
	
func _on_end_turn_button_pressed() -> void:
	state.endTurn()
