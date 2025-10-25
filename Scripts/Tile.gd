extends Node2D
class_name Tile

@onready var sprite: Sprite2D = $Sprite2D
@onready var selectable: Sprite2D = $Sprite2D/Selection

var _tileState: int = 0
var tileEffect : IEffect = null
enum TILE_STATE {
	SELECTED = 0x01,
	HOVERED = 0x08,
	SELECTABLE = 0x10,
	FLIPPED = 0x02,
	ALREADY_TRIGGERED = 0x04
}

func setStateFlag(flag: TILE_STATE, value: bool):
	if value:
		_tileState |= flag
	else:
		_tileState &= ~flag
	updateTileTexture()

func isStateFlag(flag: TILE_STATE) -> bool:
	return (_tileState & flag) == flag
	
func updateTileTexture() -> void:
	selectable.visible = false
	if isStateFlag(TILE_STATE.SELECTED):
		sprite.texture = load("res://Assets/Bestagon_flip.png")
	elif isStateFlag(TILE_STATE.HOVERED):
		sprite.texture = load("res://Assets/Bestagon_flop.png")
	elif isStateFlag(TILE_STATE.SELECTABLE):
		selectable.visible = true
	elif isStateFlag(TILE_STATE.FLIPPED):
		sprite.texture = load(tileEffect.getSpritePath())
	elif isStateFlag(TILE_STATE.ALREADY_TRIGGERED):
		sprite.texture = load(tileEffect.getSpritePathBackGround())
	else:
		sprite.texture = load("res://Assets/Backface.png")
	

func getSize() -> Vector2i:
	return Vector2i(sprite.get_rect().size)


func _on_area_2d_mouse_entered() -> void:
	SignalBus.MouseTileHover.emit($".")


func _on_area_2d_mouse_exited() -> void:
	SignalBus.MouseTileExit.emit($".")

func initEffect(effect:IEffect):
	tileEffect = effect
