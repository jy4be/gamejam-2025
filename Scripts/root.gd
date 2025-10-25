extends Node2D

@onready var map: Map = $Map
@onready var label: RichTextLabel = $UIComponents/RichTextLabel
@onready var playersNode: Node = $Players

var currentPlayer: Player
var players: Array = []
var units: Array = []

var currentHoveredTileIndex: Vector2i = Vector2i(-1, -1)
var selectedTileIndex: Vector2i = Vector2i(-1, -1)

var currentSelectedTileIndexXY: Vector2i = Vector2i(-1,-1)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	enlistPlayers()
	currentPlayer = players[0]
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
			
	createUnit(load("res://scenes/unit.tscn"), currentPlayer, Vector2i(5,5))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if selectedTileIndex != Vector2i(-1, -1):
			map.getTile(selectedTileIndex).setStateFlag(Tile.TILE_STATE.SELECTED, false)
		selectedTileIndex = currentHoveredTileIndex
		if currentHoveredTileIndex != Vector2i(-1, -1):
			if len(units) > 0:
				destroyUnit(0)
			
	if selectedTileIndex != Vector2i(-1, -1):
		map.getTile(selectedTileIndex).setStateFlag(Tile.TILE_STATE.SELECTED, true)
	label.text = "Tile: (%d;%d)\nPlayer AP: %d\nTileDistance: %d" % [currentSelectedTileIndexXY.x, currentSelectedTileIndexXY.y, currentPlayer.ActionPoints
		, map.getDistance(selectedTileIndex, currentHoveredTileIndex)]
		
	updateUnitPositions()

func turnReset():
	pass
			
func enlistPlayers() -> void:
	players.append_array(
		playersNode.get_children()
		.map(
			func(n: Node) -> Player: return n))
	
func createUnit(unitScene: Resource, owningPlayer: Player, tileIndex: Vector2i) -> void:
	var unit:Unit = Unit.New_Unit(currentPlayer, tileIndex, Unit.UNITTYPE.GENERAL)
	add_child(unit)
	units.append(unit)

func updateUnitPositions():
	for unit in units:
		var targetTile: Tile = map.getTile(unit.currentOccupiedTileIndex)
		unit.transform.origin = targetTile.transform.get_origin()
	
func destroyUnit(unitIndex: int) -> void:
	var unit: Unit = units.pop_at(unitIndex)
	unit.queue_free()
	
