extends Node2D
class_name Tile

@onready var sprite: Sprite2D = $Sprite2D


func getSize() -> Vector2i:
	print(sprite)
	return Vector2i(sprite.get_rect().size)
