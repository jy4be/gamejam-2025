extends Node2D
class_name Map

enum DIRECTIONS {UP_LEFT, UP_CENTER, UP_RIGHT, DOWN_LEFT, DOWN_CENTER, DOWN_RIGHT}

var mapSize: Vector2i
var mapBuffer: Array = Array([], TYPE_OBJECT, "Node2D", Tile)

var Units

func getDistance( tile1 : Vector2i, tile2: Vector2i):
	var diff = tile2 - tile1
	var max = abs(diff.x) + abs(diff.y)
	var positionalShortCuts = 0 
	if diff.x != 0 && diff.x%2 != 0:	
		if diff.y < 0:
			positionalShortCuts = tile1.x % 2 -1
		else:
			positionalShortCuts = tile2.x % 2 -1

	var shortCuts = min(clampi(min(abs(diff.x/2),abs(diff.y)) - positionalShortCuts,0,1000), abs(diff.y )) ;
	var maxShortcuts = min(abs(diff.x),abs(diff.y))
	shortCuts = min(shortCuts, maxShortcuts)
	return max - shortCuts

func generate(size: Vector2i):
	mapSize = size
	

	for yPos in range(mapSize.y):
		for xPos in range(mapSize.x):
			if getDistance(Vector2i(xPos,yPos),Vector2i(mapSize.x/2,mapSize.y/2)) < 5:
				var instance:Tile = createTile()
				
				var yOffset = 0
				if (xPos % 2) == 1:
					yOffset = instance.getSize().y / 2
				
				instance.transform = instance.transform.translated(
					Vector2(xPos * instance.getSize().x/4*3,yPos * instance.getSize().y + yOffset))
				mapBuffer.append(instance)
			else:
				mapBuffer.append(null)

func getRelativeTile(origin: Vector2i, dir: DIRECTIONS):
	match dir:
		DIRECTIONS.UP_LEFT:
			return getTile(origin + Vector2i(-1, 0))
		DIRECTIONS.UP_CENTER:
			return getTile(origin + Vector2i(0, -1))
		DIRECTIONS.UP_RIGHT:
			return getTile(origin + Vector2i(1, 0))
		DIRECTIONS.DOWN_LEFT:
			return getTile(origin + Vector2i(-1, 1))
		DIRECTIONS.DOWN_CENTER:
			return getTile(origin + Vector2i(0, 1))
		DIRECTIONS.DOWN_RIGHT:
			return getTile(origin + Vector2i(1, 1))
		
func getTile(pos: Vector2i) -> Tile:
	return mapBuffer[pos.y * mapSize.x + pos.x]

func getPositionOfTile(tile) -> int:
	return mapBuffer.find(tile, 0)
	
func getIndexOfTileFromBufferIndex(bufferIndex:int) -> Vector2i:
	return Vector2i(bufferIndex % mapSize.x,bufferIndex/mapSize.x)
	
func getIndexOfTile(tile: Tile) -> Vector2i:
	var pos = getPositionOfTile(tile)
	return getIndexOfTileFromBufferIndex(pos)
	
func colourPos(tile:Tile):
	var index:int = getPositionOfTile(tile)
	mapBuffer[index].sprite.texture = load("res://Assets/Bestagon_flip.png")
	
func getNeighbors(pos: Vector2i, distance = 1) -> Array[Vector2i]:
	var result:Array[Vector2i]
	for yPos in range(mapSize.y):
		for xPos in range(mapSize.x):
			var tilePos = Vector2i(xPos,yPos)
			if getDistance(tilePos,pos) <= distance && getTile(tilePos):
				result.append(tilePos)
				
	return result

func _on_root_ready() -> void:
	pass # Replace with function body.

var sceneTile: Resource = load("res://scenes/tile.tscn")


func createTile() -> Tile:
	var newTile = sceneTile.instantiate()
	add_child(newTile)
	
	var effect = GlobalVariables.Effects.keys().pick_random()
	while GlobalVariables.Effects[effect] == 0:
		effect = GlobalVariables.Effects.keys().pick_random()
	newTile.initEffect(effect.new())
	return newTile
