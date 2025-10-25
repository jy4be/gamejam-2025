extends Sprite2D
class_name Unit

@onready var sprite : Sprite2D = $"."

enum UNITTYPE {GENERAL, PAWN}

var health: int = 2
var controller: Player
var currentOccupiedTileIndex: Vector2i:
	set(tileIndex):
		currentOccupiedTileIndex = tileIndex
		var targetTile: Tile = GlobalVariables.map.getTile(currentOccupiedTileIndex)
		transform.origin = targetTile.transform.get_origin()
	get:
		return currentOccupiedTileIndex
var type: UNITTYPE

var hasMoved: bool

func setType(type: UNITTYPE):
	match type:
		UNITTYPE.GENERAL:
			sprite.texture = controller.GeneralSkin
		UNITTYPE.PAWN:
			sprite.texture = controller.PawnSkin

func turnReset():
	hasMoved = false
	
	
static func New_Unit(belongsTo: Player, occupiedTile: Vector2i, type: UNITTYPE) -> Unit:
	var scene: PackedScene = load("res://scenes/unit.tscn")
	var unit: Unit = scene.instantiate()
	unit.controller = belongsTo
	unit.health = 2
	unit.currentOccupiedTileIndex = occupiedTile
	unit.type = type
	GlobalVariables.map.add_child(unit)
	GlobalVariables.units.append(unit)
	return unit

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setType(type)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
