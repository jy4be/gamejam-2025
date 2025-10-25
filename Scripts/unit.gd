extends Sprite2D
class_name Unit

@onready var sprite : Sprite2D = $"."

enum UNITTYPE {GENERAL, PAWN}

var health: int = 2
var controller: Player

func setType(type: UNITTYPE):
	match type:
		UNITTYPE.GENERAL:
			sprite.texture = controller.GeneralSkin
		UNITTYPE.PAWN:
			sprite.texture = controller.PawnSkin

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
