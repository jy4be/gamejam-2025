extends Node2D

var map: Map
@onready var label: RichTextLabel = $Camera2D/UIComponents/RichTextLabel
@onready var playersNode: Node = $Players
@onready var gameOverScreen: Node2D = $Camera2D/GameOverScreen

var state: GameState = GameState.new()

var clickedLastFrame: bool = false

var currentHoveredTileIndex: Vector2i = Vector2i(-1, -1)
var selectedTileIndex: Vector2i = Vector2i(-1, -1)

var currentSelectedTileIndexXY: Vector2i = Vector2i(-1,-1)
var gameOver:bool = false
var gameStart:bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalVariables.sfxPlayer = $SFXplayer
	GlobalVariables.map = $Map
	map = GlobalVariables.map
	GlobalVariables.players = []
	GlobalVariables.units = []
	enlistPlayers()
	GlobalVariables.currentPlayer = GlobalVariables.players[0]
	map.generate(5)
	SignalBus.connect("MouseTileHover", 
		func(tile: Tile): 
			if !gameStart:
				return
			currentHoveredTileIndex = map.getIndexOfTile(tile)
			state.newHoverIndex(currentHoveredTileIndex)
			tile.setStateFlag(Tile.TILE_STATE.HOVERED, true)
			currentSelectedTileIndexXY = map.getIndexOfTile(tile))

	SignalBus.connect("MouseTileExit", 
		func(tile: Tile):
			tile.setStateFlag(Tile.TILE_STATE.HOVERED, false)
			if tile == map.getTile(currentHoveredTileIndex):
				currentHoveredTileIndex = Vector2i(-1, -1)
			
			)
	SignalBus.connect("GameOver",
		func(winner:Player):
			$Camera2D/GameOverScreen/Portrait.texture = winner.WinPortrait
			gameOver = true
			
	)
			
	#Unit.New_Unit(GlobalVariables.currentPlayer, Vector2i(5,5), Unit.UNITTYPE.GENERAL)
	#Unit.New_Unit(GlobalVariables.currentPlayer, Vector2i(4,4), Unit.UNITTYPE.PAWN)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
var rayOrigin:Vector2i
var raytarget:Vector2i

func _process(delta: float) -> void:
	if !gameStart:
		return
	if gameOver:
		for tile:Tile in GlobalVariables.map.mapBuffer:
				if tile:
					tile.setStateFlag(Tile.TILE_STATE.FLIPPED, true)
		
		gameOverScreen.visible = true
		return
	
	if (GlobalVariables.currentPlayer.ActionPoints == 0):
		$Camera2D/UIComponents/EndTurnButton.texture_normal = load("res://Assets/End_Turn_Button1.png")
	else:
		$Camera2D/UIComponents/EndTurnButton.texture_normal = load("res://Assets/End_Turn_Button.png")
	#debug Effects
	if Input.is_key_pressed(KEY_E):
		state.currentEffect = EffectMaprefresh.new()
		state.selectableTiles = state.currentEffect.onStart(selectedTileIndex, Vector2i(-1, -1))
		if !state.selectableTiles.is_empty():
			state.currentState = state.GAME_STATE.EFFECT
			state.setTileArrayFlag(state.selectableTiles, Tile.TILE_STATE.SELECTABLE, true)
	
	#if Input.is_key_pressed(KEY_A):
		#rayOrigin = currentHoveredTileIndex
	#if Input.is_key_pressed(KEY_D):
		#raytarget = currentHoveredTileIndex
		#print(map.findTilesAlongRay(rayOrigin, raytarget, false))
	
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) && !clickedLastFrame:
		clickedLastFrame = true
		selectedTileIndex = currentHoveredTileIndex
		#if (selectedTileIndex != Vector2i(-1,-1)):
			
		state.updateGameState(selectedTileIndex)
		
	elif !Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		clickedLastFrame = false
	if state.currentState == GameState.GAME_STATE.LAUNCH:
		state.updateGameState(selectedTileIndex)

	label.text = "Tile: (%d;%d)\nPlayer AP: %d\n GameState: %s\nCurrentPlayer: %s"%  [
		currentSelectedTileIndexXY.x, currentSelectedTileIndexXY.y, 
		GlobalVariables.currentPlayer.ActionPoints, 
		str(state.currentState),
		GlobalVariables.currentPlayer.PlayerName]
	var apDisplay: APDisplay = $Camera2D/UIComponents/AP
	apDisplay.setAPAmount(GlobalVariables.currentPlayer.ActionPoints)
	var playerName: Label = $Camera2D/UIComponents/PlayerName
	playerName.text = GlobalVariables.currentPlayer.PlayerName
	var portrait: Sprite2D = $Camera2D/UIComponents/Portrait
	portrait.texture = GlobalVariables.currentPlayer.Portrait
	var flavorText: RichTextLabel = $Camera2D/UIComponents/FlavorText
	flavorText.text = ""
	if currentHoveredTileIndex != Vector2i(-1,-1) and map.getTile(currentHoveredTileIndex).isStateFlag(Tile.TILE_STATE.FLIPPED):
		flavorText.push_color(Color("#aba09c"))
		flavorText.add_text(map.getTile(currentHoveredTileIndex).tileEffect.getFlavorText())

	

			
func enlistPlayers() -> void:
	GlobalVariables.players.append_array(
		playersNode.get_children())

	
func destroyUnit(unitIndex: int) -> void:
	var unit: Unit = GlobalVariables.units.pop_at(unitIndex)
	unit.queue_free()
	
func _on_end_turn_button_pressed() -> void:
	state.endTurn()
	

func _on_audio_stream_player_2_finished() -> void:
	$AudioStreamPlayer.play()
	print("Audio loop started")
	

func _on_start_pressed() -> void:
	$Camera2D/MainMenu.visible = false
	gameStart = true

func _on_texture_button_pressed() -> void:
	get_tree().reload_current_scene()
