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
					"type": 0 ,
					"x" : x,
					"y" : y,
					"vertical" : false,
					"boat" : -1
					
			}
			set_cell(0, Vector2(x,y), 2 , Vector2i(0,0), 0) 
			set_cell(1, Vector2(x,y), 8 , Vector2i(0,0), 0) 
			
	## Setting up Enemy Board
	for x in range(gameController.gridSize + gameController.gridDistance, 2*gameController.gridSize+gameController.gridDistance) : 
		for y in gameController.gridSize: 
			gameController.enemyBoard[str(Vector2(x,y))] = {
					"type": 0 ,
					"x" : x,
					"y" : y,
					"vertical" : false,
					"boat" : -1
					
			}
			set_cell(0, Vector2(x,y), 2 , Vector2i(0,0), 0) 
			set_cell(1, Vector2(x,y), 8 , Vector2i(0,0), 0) 

func locateShip(tile, board): 
	var ship = {}
	for boardTile in board :
		if boardTile["boat"] == board[str(tile)]["boat"] : 
			ship[str(Vector2(board[str(tile)]["x"],board[str(tile)]["y"]))] = boardTile
	return ship
	##return  {piece : data for piece, data in board.items() if data.get("boat") == board[str(tile)]["boat"]}

func attack(tile, board):
	if board[str(tile)]["type"] > 1 : 
		if board[str(tile)]["type"] == 2 : 
			board[str(tile)]["type"] = 0
		else :
			board[str(tile)]["type"] = 1		
		set_cell(0, Vector2(board[str(tile)]["x"],board[str(tile)]["y"]), board[str(tile)]["type"] , Vector2i(0,0), 0) 	

func rotateShip(tile, board):
	if board[str(tile)]["type"] > 2 :		
		var ship = locateShip(tile, board)
		if 	board[str(tile)]["vertical"] :
			for n in range (1, gameController.shipSize[ship[0]["type"]]) : 
				if board[str(Vector2(board[str(tile)]["x"]+n, board[str(tile)]["y"]))]["type"] > 2 :
					return
			for n in range (1, gameController.shipSize[ship[0]["type"]]) : 
				set_cell(0, Vector2(board[str(tile)]["x"]+n,board[str(tile)]["y"]), board[str(tile)]["type"] , Vector2i(0,0), 0) 	
				set_cell(0, Vector2(board[str(tile)]["x"],board[str(tile)]["y"]+n), 2 , Vector2i(0,0), 0) 	

func moveShip(tile): 
	pass
			
func selectTile(tile):	
		set_cell(1, tile, 0, Vector2i(0,0), 0)
		aux = tile
		
func setupGame():
	gameController.playerBoard.clear()
	gameController.enemyBoard.clear()

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
			rotateShip(tile, gameController.playerBoard)
	if gameController.enemyBoard.has(str(tile)):
		selectTile(tile)	
		if(Input.is_action_just_pressed("mb_left")):
			attack(tile, gameController.enemyBoard)
