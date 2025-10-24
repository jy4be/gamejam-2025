extends Node2D
class_name Map



var x:int
var y:int
var mapBuffer: Array = Array([], TYPE_OBJECT, "Node2D", Tile)


func generate(sizeX: int, sizeY: int):
	x = sizeX
	y = sizeY
	var scene: Resource = load("res://tile.tscn")
	
	for yPos in range(y):
		for xPos in range(x):
			var instance:Tile = scene.instantiate()
			add_child(instance)
			var yOffset = 0
			if (xPos % 2) == 1:
				yOffset = instance.getSize().y / 2
				
			instance.transform = instance.transform.translated(
				Vector2(xPos * instance.getSize().x/4*3,yPos * instance.getSize().y + yOffset))
			mapBuffer.append(instance)
			
		
func getTile(x, y):
	pass
func getPositionOfTile(tile):
	pass



func _on_ready() -> void:
	generate(5,5)
