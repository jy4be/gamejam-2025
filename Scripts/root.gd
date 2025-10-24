extends Node2D

@onready var map: Map = $Map
@onready var label: RichTextLabel = $RichTextLabel

var currentPlayer: Player
var Players: Array = [Player.new("ONE", "res://Assets/Shogun_blau.png"), Player.new("TWO", "res://Assets/Shogun_rot.png")]
var currentSelectedTileIndex: int = -1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	map.generate(Vector2i(10, 10))
	SignalBus.connect("MouseTileHover", 
		func(tile: Tile): 
			currentSelectedTileIndex = map.getPositionOfTile(tile))
	SignalBus.connect("MouseTileExit", 
		func(tile: Tile):
			if tile == map.mapBuffer[currentSelectedTileIndex]:
				currentSelectedTileIndex = -1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	label.text = "Tile: " + str(currentSelectedTileIndex)
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if currentSelectedTileIndex >= 0:
			createUnit(load("res://scenes/unit.tscn"), currentPlayer, currentSelectedTileIndex)

	
func createUnit(unitScene, owningPlayer: Player, tileIndex: int):
	var unit: Unit = unitScene.instantiate()
	add_child(unit)
	unit.controller = owningPlayer
	unit.health = 2
	unit.setType(Unit.UNITTYPE.GENERAL)
	var tileToSpawn: Tile = map.mapBuffer[tileIndex]
	unit.transform.origin = tileToSpawn.transform.get_origin()
	
