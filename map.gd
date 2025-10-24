extends Node2D
class_name Map



var mapSize: Vector2i
var mapBuffer: Array = Array([], TYPE_OBJECT, "Node2D", Tile)

enum DIRECTIONS {UP_LEFT, UP_CENTER, UP_RIGHT, DOWN_LEFT, DOWN_CENTER, DOWN_RIGHT}

func generate(size: Vector2i):
	mapSize = size
	var scene: Resource = load("res://tile.tscn")
	
	for yPos in range(mapSize.y):
		for xPos in range(mapSize.x):
			var instance:Tile = scene.instantiate()
			add_child(instance)
			var yOffset = 0
			if (xPos % 2) == 1:
				yOffset = instance.getSize().y / 2
				
			instance.transform = instance.transform.translated(
				Vector2(xPos * instance.getSize().x/4*3,yPos * instance.getSize().y + yOffset))
			mapBuffer.append(instance)

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
		
func getTile(pos: Vector2i):
	return mapBuffer[pos.y * mapSize.x + pos.x]

func getPositionOfTile(tile):
	pass



func _on_ready() -> void:
	generate(Vector2i(5, 5))
