extends Node

class_name Player

var ActionPoints: int = 2
var playerName: String
var generalSkin: Resource
var pawnSkin: Resource

func _init(pName: String, generalSkinLoc: String) -> void:
	playerName = pName
	generalSkin = load(generalSkinLoc)
	#pawnSkin = load(pawnSkinLoc)
	
func getGeneralSkin() -> Resource:
	return generalSkin

func getPawnSkin() -> Resource:
	return pawnSkin
