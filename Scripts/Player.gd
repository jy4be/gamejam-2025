extends Node

class_name Player

const ACTION_POINT_MAX: int = 2

var ActionPoints: int = ACTION_POINT_MAX
@export var GeneralSkin: Resource
@export var PawnSkin: Resource
@export var PlayerName: String

func turnReset():
	ActionPoints = ACTION_POINT_MAX
