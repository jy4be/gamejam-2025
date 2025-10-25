extends Sprite2D
class_name Unit

@onready var sprite : Sprite2D = $"."

enum UNITTYPE {GENERAL, PAWN}

var health: int = 2
var controller: Player
var currentOccupiedTileIndex: int

var _hasMoved: bool

func setType(type: UNITTYPE):
	match type:
		UNITTYPE.GENERAL:
			sprite.texture = controller.GeneralSkin
		UNITTYPE.PAWN:
			sprite.texture = controller.PawnSkin

func turnReset():
	pass
	
func move(tileIndex: int) -> void:
	pass
	
static func New_Unit(belongsTo: Player, occupiedTile: int, type: UNITTYPE) -> Unit:
	var scene: PackedScene = load("res://scenes/unit.tscn")
	var unit: Unit = scene.instantiate()
	print(belongsTo.GeneralSkin)
	unit.controller = belongsTo
	unit.health = 2
	unit.currentOccupiedTileIndex = occupiedTile
	unit.setType(type)
	return unit

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
