extends Node2D

enum state {PREPARING, PLAYERTURN, ENEMYTURN, RESULT}
var current_state: state = state.PREPARING

const gridSize = 10
const gridDistance = 2

@export var playerBoard = {} 
@export var enemyBoard = {}

const shipSize = {
	3 : 4,
	4 : 5,
	5 : 3,
	6 : 2,
	7 : 3
}
