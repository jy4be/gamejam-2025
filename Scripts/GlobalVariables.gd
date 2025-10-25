extends Node

var map: Map = null
var units: Array[Unit] = []
var players: Array[Player] = []
var currentPlayer: Player = null


#var Effects : Dictionary = {
	#EffectDummy : 20,
	#EffectBaseAttack : 10,
	#EffectBlume : 6,
	#EffectHeal : 6,
	#EffectMaprefresh : 2,
	#EffectIncrementActionPoints : 4,
	#EffectIncrementUnit : 4,
	#EffectShot: 2
	#}
	
#DEBUG 
var Effects : Dictionary = {
	EffectShot : 100,
	}
