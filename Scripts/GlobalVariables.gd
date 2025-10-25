extends Node

var map: Map = null
var units: Array[Unit] = []
var players: Array[Player] = []
var currentPlayer: Player = null


var Effects : Dictionary = {
	EffectDummy : 20,
	EffectBaseAttack : 10,
	EffectBlume : 6,
	EffectHeal : 6
	}
