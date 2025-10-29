extends Sprite2D
class_name Unit

@onready var sprite : Sprite2D = $"."
@onready var heart1: Sprite2D = $"Heart 1"
@onready var heart2: Sprite2D = $"Heart 2"
@onready var slashAnim: AnimatedSprite2D = $SlashAnim
@onready var animPlayer: AnimationPlayer = $AnimationPlayer

enum UNITTYPE {GENERAL, PAWN}

var health: int = 2:
	set(h):
		if h < health:
			slashAnim.play("slash")
			GlobalVariables.sfxPlayer.stream = load("res://Assets/explosion (1).wav")
			GlobalVariables.sfxPlayer.play()
		else:
			slashAnim.play("Heal")
		health = h
		if health <= 0:
			GameState.units.erase(self)
			if type == UNITTYPE.GENERAL:
				var winner = GameState.players.find_custom(func (p:Player):return p!=controller)
				if winner != -1:
					SignalBus.GameOver.emit(GameState.players[winner])
			self.queue_free()
		print("update health to ",health)
		
		updateHearts()
	get:
		return health
var controller: Player
var currentOccupiedTileIndex: Vector2i:
	set(tileIndex):
		currentOccupiedTileIndex = tileIndex
		var targetTile: Tile = Map.getTile(currentOccupiedTileIndex)
		transform.origin = targetTile.transform.get_origin()
		if animPlayer:
			animPlayer.play("moveSet")
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
	unit.currentOccupiedTileIndex = occupiedTile
	unit.type = type
	Map.referenceTile.add_child(unit)
	unit.heal()
	unit.heart1.texture = load("res://Assets/HP_full.png")
	if type == UNITTYPE.PAWN:
		unit.heart2.visible = false
	GameState.units.append(unit)
	return unit

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setType(type)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func heal() -> void:
	print(heal)
	match type:
		UNITTYPE.GENERAL:
			health = 2
		UNITTYPE.PAWN:
			health = 1
	

func updateHearts():
	if health >= 2:
		heart2.texture = load("res://Assets/HP_full.png")
	else:
		heart2.texture = load("res://Assets/HP_empty.png")
