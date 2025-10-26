extends Node2D
class_name Tile

@onready var sprite: Sprite2D = $Sprite2D
@onready var selectable: Sprite2D = $Sprite2D/Selection
@onready var hover: Sprite2D = $Sprite2D/Hover
@onready var debugMark: Sprite2D = $Sprite2D/DebugMark
@onready var targerMark: Sprite2D = $Sprite2D/TargetMarker

var _isFlipped: bool = false
var _currentFlipAnimTimer: float = 0
const FLIP_ANIMATION_DURATION: float = 1
var _flipA: Resource
var _flipB: Resource
@onready var originalTransform: Transform2D = sprite.transform

var _tileState: int = 0
var tileEffect : IEffect = null
enum TILE_STATE {
	SELECTED = 0x01,
	HOVERED = 0x08,
	SELECTABLE = 0x10,
	FLIPPED = 0x02,
	ALREADY_TRIGGERED = 0x04,
	DEBUG = 0x20,
	EFFECT_PREVIEW_TARGET = 0x40
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
	debugMark.visible = false
	targerMark.visible = false
	sprite.texture = load("res://Assets/BackfaceVariant.png")
	#if isStateFlag(TILE_STATE.SELECTED):
		#sprite.texture = load("res://Assets/Bestagon_flip.png")
	if isStateFlag(TILE_STATE.EFFECT_PREVIEW_TARGET):
		targerMark.visible = true
	if isStateFlag(TILE_STATE.HOVERED):
		hover.visible = true
		if isStateFlag(TILE_STATE.FLIPPED):
			hideUnit(true)
	if isStateFlag(TILE_STATE.SELECTABLE):
		selectable.visible = true
	if isStateFlag(TILE_STATE.DEBUG):
		debugMark.visible = true
	if isStateFlag(TILE_STATE.FLIPPED):
		sprite.texture = load(tileEffect.getSpritePath())
	if isStateFlag(TILE_STATE.ALREADY_TRIGGERED):
		sprite.texture = load(tileEffect.getSpritePathBackGround())
		
func flip(state: bool):
	if _isFlipped == state:
		return
	_isFlipped = state
	if isStateFlag(TILE_STATE.ALREADY_TRIGGERED):
		return
	if state:
		setStateFlag(TILE_STATE.FLIPPED, true)
		_flipA = load("res://Assets/BackfaceVariant.png")
		_flipB = sprite.texture
	else:
		_flipA = sprite.texture
		_flipB = load("res://Assets/BackfaceVariant.png")
		setStateFlag(TILE_STATE.FLIPPED, false)
	_currentFlipAnimTimer = FLIP_ANIMATION_DURATION
	
	
	
func _process(delta: float) -> void:
	if _currentFlipAnimTimer > 0:
		_currentFlipAnimTimer -= max(delta, 0)
		if _currentFlipAnimTimer > FLIP_ANIMATION_DURATION / 2:
			sprite.transform = originalTransform.scaled(
				Vector2(1, (_currentFlipAnimTimer - (FLIP_ANIMATION_DURATION/2)) / (FLIP_ANIMATION_DURATION/2)))
			sprite.texture = _flipA
		else:
			sprite.texture = _flipB
			sprite.transform = originalTransform.scaled(
				Vector2(1, ((FLIP_ANIMATION_DURATION/2) - _currentFlipAnimTimer) / (FLIP_ANIMATION_DURATION/2)))

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
