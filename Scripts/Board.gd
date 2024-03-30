extends TileMap

@onready var gameController = GameController

var tile = null
var aux = null

# Called when the node enters the scene tree for the first time.
func _ready(): 		
	## Setting up Player Board
	for x in gameController.gridSize:
		for y in gameController.gridSize:
			gameController.playerBoard[str(Vector2(x,y))] = {
					"type": "default" ,
					"x" : x,
					"y" : y,
					"vertical" : false
					
			}
			set_cell(0, Vector2(x,y), 2 , Vector2i(0,0), 0) 
			set_cell(1, Vector2(x,y), 8 , Vector2i(0,0), 0) 
			
	## Setting up Enemy Board
	for x in range(gameController.gridSize + gameController.gridDistance, 2*gameController.gridSize+gameController.gridDistance) : 
		for y in gameController.gridSize: 
			gameController.enemyBoard[str(Vector2(x,y))] = {
					"type": "default" ,
					"x" : x,
					"y" : y,
					"vertical" : false
					
			}
			set_cell(0, Vector2(x,y), 2 , Vector2i(0,0), 0) 
			set_cell(1, Vector2(x,y), 8 , Vector2i(0,0), 0) 

func attack(tile):
	pass

func rotateShip(tile):
	pass

func moveShip(tile): 
	pass
			
func selectTile(tile):	
		set_cell(1, tile, 0, Vector2i(0,0), 0)
		aux = tile

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):		
	tile = local_to_map(get_global_mouse_position())
	if aux != null :
			set_cell(1, aux, 8, Vector2i(0,0), 0)
	if gameController.playerBoard.has(str(tile)):
		selectTile(tile)	
		if(Input.is_action_just_pressed("mb_left")):
			moveShip(tile)
		if(Input.is_action_just_pressed("mb_right")):
			rotateShip(tile)
	if gameController.enemyBoard.has(str(tile)):
		selectTile(tile)	
		if(Input.is_action_just_pressed("mb_left")):
			attack(tile)
