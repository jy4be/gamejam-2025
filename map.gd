extends Node2D
class_name Map



var x:int
var y:int
var mapBuffer: Array = Array([], TYPE_OBJECT, "Node2D", Tile)


func generate(sizeX: int, sizeY: int):
	x = sizeX
	y = sizeY
	var scene: Resource = load("res://tile.tscn")
	var instance = scene.instantiate()
	add_child(instance)
	#for n in range(x*y):
		
func getTile(x, y):
	pass
func getPositionOfTile(tile):
	pass



func _on_ready() -> void:
	generate(0,0)
