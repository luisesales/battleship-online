extends Node2D

enum state {PREPARING, PLAYERTURN, ENEMYTURN, RESULT}
var current_state: state = state.PREPARING

const gridSize = 10
const gridDistance = 2

@onready var battleship = $Battleship
@onready var carrier = $Carrier 
@onready var destroyer = $Destroyer
@onready var patrolBoat = $PatrolBoat
@onready var submarine = $Submarine

@export var playerBoard = {} 
@export var enemyBoard = {}

const shipSize = {
	3 : 4,
	4 : 5,
	5 : 3,
	6 : 2,
	7 : 3
}

var tilesBoats = {
	3 : battleship,
	4 : carrier,
	5 : destroyer,
	6 : patrolBoat,
	7 : submarine
}

var boatsTiles = {
	battleship : 3,
	carrier : 4,
	destroyer : 5,
	patrolBoat : 6,
	submarine : 7
}

var selectedShip = null

