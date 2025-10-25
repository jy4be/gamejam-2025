extends Node2D

@onready var map: Map = $Map
@onready var label: RichTextLabel = $UIComponents/RichTextLabel
@onready var playersNode: Node = $Players

var currentPlayer: Player
var players: Array = []
var currentSelectedTileIndex: int = -1
var currentSelectedTileIndexXY: Vector2i = Vector2i(-1,-1)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	enlistPlayers()
	currentPlayer = players[0]
	map.generate(Vector2i(10, 10))
	SignalBus.connect("MouseTileHover", 
		func(tile: Tile): 
			currentSelectedTileIndex = map.getPositionOfTile(tile)
			currentSelectedTileIndexXY = map.getIndexOfTile(tile))
	SignalBus.connect("MouseTileExit", 
		func(tile: Tile):
			if tile == map.mapBuffer[currentSelectedTileIndex]:
				currentSelectedTileIndex = -1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	label.text = "Tile: %d (%d;%d)\nPlayer AP: %d" % [currentSelectedTileIndex,currentSelectedTileIndexXY.x, currentSelectedTileIndexXY.y, currentPlayer.ActionPoints]
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if currentSelectedTileIndex >= 0:
			createUnit(load("res://scenes/unit.tscn"), currentPlayer, currentSelectedTileIndex)
			
func enlistPlayers() -> void:
	players.append_array(
		playersNode.get_children()
		.map(
			func(n: Node) -> Player: return n))
	
func createUnit(unitScene, owningPlayer: Player, tileIndex: int) -> void:
	var unit: Unit = unitScene.instantiate()
	add_child(unit)
	unit.controller = owningPlayer
	unit.health = 2
	unit.setType(Unit.UNITTYPE.GENERAL)
	var tileToSpawn: Tile = map.mapBuffer[tileIndex]
	unit.transform.origin = tileToSpawn.transform.get_origin()
	
