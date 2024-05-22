extends Node2D

##Game State 
enum state {LOBBY,PREPARING, PLAYERTURN, ENEMYTURN, RESULT}
var current_state: state = state.PREPARING

var players = {}

##Constant variables
const gridSize = 10
const gridDistance = 2
const shipSize = {
	3 : 4,
	4 : 5,
	5 : 3,
	6 : 2,
	7 : 3
}

##Script associated nodes
var battleship 
var carrier 
var destroyer 
var patrolBoat
var submarine

##Script Generated Dictionaries
@export var playerBoard = {} 
@export var enemyBoard = {}
var tilesBoats 
var boatsTiles 

##Control variable
var selectedShip = null

	

