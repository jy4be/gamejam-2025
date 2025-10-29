extends Node2D

@onready var label: RichTextLabel = $Camera2D/UIComponents/RichTextLabel
@onready var playersNode: Node = $Players
@onready var gameOverScreen: Node2D = $Camera2D/GameOverScreen
@onready var endTurnButton: TextureButton = $Camera2D/UIComponents/EndTurnButton

var clickedLastFrame: bool = false

var currentHoveredTileIndex: Vector2i = Vector2i(-1, -1)
var selectedTileIndex: Vector2i = Vector2i(-1, -1)

var gameOver:bool = false
var gameStart:bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalVariables.sfxPlayer = $SFXplayer
	GameState.initializeGame(playersNode.get_children(), $Map)
	
	SignalBus.connect("MouseTileHover", 
		func(tile: Tile): 
			if !gameStart:
				return
			currentHoveredTileIndex = tile.index
			GameState.newHoverIndex(currentHoveredTileIndex)
			tile.setStateFlag(Tile.TILE_STATE.HOVERED, true)
	)
	SignalBus.connect("MouseTileExit", 
		func(tile: Tile):
			tile.setStateFlag(Tile.TILE_STATE.HOVERED, false)
			if tile == Map.getTile(currentHoveredTileIndex):
				currentHoveredTileIndex = Vector2i(-1, -1)
	)
	SignalBus.connect("GameOver",
		func(winner:Player):
			$Camera2D/GameOverScreen/Portrait.texture = winner.WinPortrait
			gameOver = true
	)
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.

func _process(delta: float) -> void:
	if !gameStart:
		return
	if gameOver:
		for tile:Tile in Map.mapBuffer.filter(func(t): return t):
			tile.setStateFlag(Tile.TILE_STATE.FLIPPED, true)
		gameOverScreen.visible = true
		return
	
	var hasCurrentPlayerLeftMoves: bool =\
		GameState.currentPlayer.ActionPoints > 0 and\
		GameState.units.find_custom(
			func(u:Unit):
				return u.controller == GameState.currentPlayer and\
					   not u.hasMoved) == -1
	if GameState.currentState == GameState.GAME_STATE.NORMAL and hasCurrentPlayerLeftMoves:
		endTurnButton.texture_normal = load("res://Assets/UIElements/End_Turn_Button1.png")
	else:
		endTurnButton.texture_normal = load("res://Assets/UIElements/End_Turn_Button.png")

	
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) && !clickedLastFrame:
		clickedLastFrame = true
		selectedTileIndex = currentHoveredTileIndex
		GameState.updateGameState(selectedTileIndex)
		
	elif !Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		clickedLastFrame = false

	var apDisplay: APDisplay = $Camera2D/UIComponents/AP
	apDisplay.setAPAmount(GameState.currentPlayer.ActionPoints)
	var playerName: Label = $Camera2D/UIComponents/PlayerName
	playerName.text = GameState.currentPlayer.PlayerName
	var portrait: Sprite2D = $Camera2D/UIComponents/Portrait
	portrait.texture = GameState.currentPlayer.Portrait
	var flavorText: RichTextLabel = $Camera2D/UIComponents/FlavorText
	flavorText.text = ""
	if currentHoveredTileIndex != Vector2i(-1,-1) and\
		Map\
			.getTile(currentHoveredTileIndex)\
			.isStateFlag(Tile.TILE_STATE.FLIPPED):
		flavorText.push_color(Color("#aba09c"))
		flavorText.add_text(Map.getTile(currentHoveredTileIndex).tileEffect.getFlavorText())
	
func _on_end_turn_button_pressed() -> void:
	GameState.endTurn()

func _on_start_pressed() -> void:
	$Camera2D/MainMenu.visible = false
	gameStart = true

func _on_texture_button_pressed() -> void:
	get_tree().reload_current_scene()
