extends Node

class_name Player

const STARTING_GENERALS = 2

const ACTION_POINT_MAX: int = 3

var ActionPoints: int = ACTION_POINT_MAX
var generalsToPlace: int = STARTING_GENERALS
@export var GeneralSkin: Resource
@export var PawnSkin: Resource
@export var Portrait: Resource
@export var PlayerName: String

func turnReset():
	ActionPoints = ACTION_POINT_MAX
