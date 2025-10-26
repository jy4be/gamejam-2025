extends Node

var map: Map = null
var units: Array[Unit] = []
var players: Array[Player] = []
var currentPlayer: Player = null



"""var Effects : Dictionary = {
	#EffectDummy : 4,
	EffectBaseAttack : 10,
	EffectBogen:10,
	EffectMaprefresh : 2,
	EffectHeal : 6,
	EffectIncrementActionPoints : 4,
	EffectIncrementUnit : 4,
	EffectShot: 2,
	EffectFalle: 4,
	EffectTeleport: 4,
	EffectBlume : 6,
	EffectFireBall : 4,
	EffectKettenblitz :4
	}"""
	
#DEBUG 

var Effects : Dictionary = {
	EffectBogen : 100,
	}
