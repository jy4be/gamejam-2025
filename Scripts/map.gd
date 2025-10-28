extends Node2D
class_name Map

enum DIRECTIONS {UP_LEFT, UP_CENTER, UP_RIGHT, DOWN_LEFT, DOWN_CENTER, DOWN_RIGHT}
@onready var mountain: Sprite2D  = $mountain
var mapRadius = 5;
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

func generate(size: int):
	if size == -1:
		size = mapRadius
	mapSize = Vector2i(size*2,size*2)
	mapBuffer.clear()
	var tilePool : Array
	for key in GlobalVariables.Effects:
		for temp in range(GlobalVariables.Effects[key]):
			tilePool.append(key)

	print("TilePool size",tilePool.size())
	for yPos in range(mapSize.y):
		for xPos in range(mapSize.x):
			if yPos == 0.5 *mapSize.y && xPos == 0.5 *mapSize.x:
				# Fujigon
				mapBuffer.append(null)
				continue
			
			if getDistance(Vector2i(xPos,yPos),Vector2i(mapSize.x/2,mapSize.y/2)) < size:
				var instance:Tile = createTile(tilePool)
				var tileSize = instance.getSize()
				var yOffset = 0
				if (xPos % 2) == 1:
					yOffset = instance.getSize().y / 2
				var pos =Vector2(xPos * instance.getSize().x/4*3,yPos * instance.getSize().y + yOffset)
				
				instance.transform = instance.transform.translated(pos)
				mapBuffer.append(instance)
			else:
				mapBuffer.append(null)
	print("TilePool size after generate",tilePool.size())

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
	
func getIndexOfTileFromBufferIndex(bufferIndex:int) -> Vector2i:
	return Vector2i(bufferIndex % mapSize.x,bufferIndex/mapSize.x)
	
func getIndexOfTile(tile: Tile) -> Vector2i:
	return getIndexOfTileFromBufferIndex(mapBuffer.find(tile))
	
func colourPos(tile:Tile):
	tile.sprite.texture = load("res://Assets/Bestagon_flip.png")
	
func getNeighbors(pos: Vector2i, distanceMax = 1,distanceMin = 0) -> Array[Vector2i]:
	var result:Array[Vector2i]
	for yPos in range(mapSize.y):
		for xPos in range(mapSize.x):
			var tilePos = Vector2i(xPos,yPos)
			if getDistance(tilePos,pos) <= distanceMax && getDistance(tilePos,pos) >= distanceMin && getTile(tilePos):
				result.append(tilePos)
				
	return result

var sceneTile: Resource = load("res://scenes/tile.tscn")

func findTilesAlongRay(origin: Vector2i, target: Vector2, isInfinite: bool) -> Array[Vector2i]:
	var pos1: Vector2 = getTile(origin).global_position
	var pos2: Vector2 = pos1 + (getTile(target).global_position - pos1) * 1000

	var hitTiles: Array[Tile] = []
	var startPoint: Vector2 = pos1
	
	while(getTile(target) not in hitTiles or isInfinite):
		var space_state: PhysicsDirectSpaceState2D = get_world_2d().direct_space_state
		var query = PhysicsRayQueryParameters2D.create(startPoint, pos2)
		query.collide_with_areas = true
		query.exclude = hitTiles.map(func(t:Tile): return t.sprite.get_children(true)[0])
		var result = space_state.intersect_ray(query)
		if !result:
			break
		startPoint = result.position
		var colOb: Node = result.collider as Node
		if !colOb:	
			break
		var baseTile: Tile = colOb.get_parent().get_parent() as Tile
		hitTiles.append(baseTile)
	
	var hitTilesIndicies: Array[Vector2i]
	hitTilesIndicies.assign(hitTiles.map(func(t:Tile): return getIndexOfTile(t)))
	return hitTilesIndicies

func createTile(tilePool : Array) -> Tile:
	var newTile:Tile = sceneTile.instantiate()
	add_child(newTile)
	
	if(tilePool.is_empty()):
		newTile.initEffect(EffectDummy.new())
		#newTile.setStateFlag(Tile.TILE_STATE.FLIPPED,true)
		return newTile
		
	var effect = tilePool.pick_random()
	tilePool.erase(effect)
	newTile.initEffect(effect.new())
	#newTile.setStateFlag(Tile.TILE_STATE.FLIPPED,true)
	return newTile
	
static func getUnitOnTile(tileIndex : Vector2i) -> Unit:
	var index = GlobalVariables.units.find_custom(func (unit : Unit): 
			return unit.currentOccupiedTileIndex == tileIndex)
	if index != -1 :
		return GlobalVariables.units[index]
	return null
