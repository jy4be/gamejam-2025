extends Node2D
class_name Tile

@onready var sprite: Sprite2D = $Sprite2D
@onready var selectable: Sprite2D = $Sprite2D/Selection
@onready var hover: Sprite2D = $Sprite2D/Hover

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
	hideUnit(false)
	
	selectable.visible = false
	hover.visible = false
	sprite.texture = load("res://Assets/BackfaceVariant.png")
	#if isStateFlag(TILE_STATE.SELECTED):
		#sprite.texture = load("res://Assets/Bestagon_flip.png")
	if isStateFlag(TILE_STATE.HOVERED):
		hover.visible = true
		if isStateFlag(TILE_STATE.FLIPPED):
			hideUnit(true)
	if isStateFlag(TILE_STATE.SELECTABLE):
		selectable.visible = true
	if isStateFlag(TILE_STATE.FLIPPED):
		sprite.texture = load(tileEffect.getSpritePath())
	if isStateFlag(TILE_STATE.ALREADY_TRIGGERED):
		sprite.texture = load(tileEffect.getSpritePathBackGround())
		
	

func getSize() -> Vector2i:
	return Vector2i(sprite.get_rect().size)

func hideUnit(hide:bool):
	var unit:Unit = IEffect.getUnitOnTile(GlobalVariables.map.getIndexOfTile(self))
	if unit:
		unit.visible = !hide

func _on_area_2d_mouse_entered() -> void:
	SignalBus.MouseTileHover.emit($".")


func _on_area_2d_mouse_exited() -> void:
	SignalBus.MouseTileExit.emit($".")

func initEffect(effect:IEffect):
	tileEffect = effect
