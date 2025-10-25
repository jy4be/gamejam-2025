extends Node

class_name Player

const STARTING_GENERALS = 2

const ACTION_POINT_MAX: int = STARTING_GENERALS

var ActionPoints: int = ACTION_POINT_MAX
var generalsToPlace: int
@export var GeneralSkin: Resource
@export var PawnSkin: Resource
@export var PlayerName: String

func turnReset():
	ActionPoints = ACTION_POINT_MAX
