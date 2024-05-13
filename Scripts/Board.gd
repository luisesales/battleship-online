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

func locateShipTip(tile, board): 
	var shipTip 
	for boardTile in board :
		if boardTile["boat"] == board[str(tile)]["boat"] : 
			shipTip = boardTile
			return shipTip
	
	##return  {piece : data for piece, data in board.items() if data.get("boat") == board[str(tile)]["boat"]}

func attack(tile, board):
	##Checking if tile hasn't been attacked
	if board[str(tile)]["type"] > 1 : 
		
		##Checking if tile is a water tile
		if board[str(tile)]["type"] == 2 : 
			
			##Updating to miss tile
			board[str(tile)]["type"] = 0
			
		else :
			
			##Updating to hit tile
			board[str(tile)]["type"] = 1	
				
		set_cell(0, Vector2(board[str(tile)]["x"],board[str(tile)]["y"]), board[str(tile)]["type"] , Vector2i(0,0), 0) 	

func rotateShip(tile, board):
	##Checking if There's a boat in tile
	if board[str(tile)]["type"] > 2 :
			
		##Locating ship's tip on board	
		var shipTip = locateShipTip(tile, board)
		
		##Checking if boat's on the vertical 
		if 	shipTip["vertical"] :
			
			##Checking if the new position are unoccupied
			for n in range (1, gameController.shipSize[shipTip["type"]]) : 
				if board[Vector2(shipTip["x"]+n,shipTip["y"])]["type"] > 2 :
					return
			
			##Updating positions
			for n in range (1, gameController.shipSize[shipTip["type"]]) : 
				
				##Occupying new positions
				set_cell(0, Vector2(shipTip["x"]+n,shipTip["y"]), shipTip["type"] , Vector2i(0,0), 0) 	
				board[Vector2(shipTip["x"]+n,shipTip["y"])]["type"] = shipTip["type"]
				board[Vector2(shipTip["x"]+n,shipTip["y"])]["boat"] = shipTip["boat"]
				##board[Vector2(shipTip["x"]+n,shipTip["y"])]["vertical"] = false
				
				##Clearing old positions
				set_cell(0, Vector2(shipTip["x"],shipTip["y"]+n), 2 , Vector2i(0,0), 0)
				board[Vector2(shipTip["x"],shipTip["y"]+n)]["type"] = 2
				board[Vector2(shipTip["x"],shipTip["y"]+n)]["boat"] = -1
				board[Vector2(shipTip["x"],shipTip["y"]+n)]["vertical"] = false
				
		else : 
			
			##Checking if the new position are unoccupied
			for n in range (1, gameController.shipSize[shipTip["type"]]) : 
				if board[Vector2(shipTip["x"],shipTip["y"]+n)]["type"] > 2 :
					return
					
			##Updating positions
			for n in range (1, gameController.shipSize[shipTip["type"]]) : 
				
				##Occupying new positions
				set_cell(0, Vector2(shipTip["x"],shipTip["y"]+n), shipTip["type"] , Vector2i(0,0), 0) 	
				board[Vector2(shipTip["x"],shipTip["y"]+n)]["type"] = shipTip["type"]
				board[Vector2(shipTip["x"],shipTip["y"]+n)]["boat"] =  shipTip["boat"]
				board[Vector2(shipTip["x"],shipTip["y"]+n)]["vertical"] = true
				
				##Clearing old positions
				set_cell(0, Vector2(shipTip["x"]+n,shipTip["y"]), 2 , Vector2i(0,0), 0)
				board[Vector2(shipTip["x"]+n,shipTip["y"])]["type"] = 2
				board[Vector2(shipTip["x"]+n,shipTip["y"])]["boat"] = -1
				board[Vector2(shipTip["x"]+n,shipTip["y"])]["vertical"] = false

func moveShip(tile): 
	##Checks if the tile has a boat
	if(gameController.playerBoard[str(tile)]["type"] > 2):
		
		##Shows nad positions the selected boat into the clicked space
		var shipTip = locateShipTip(tile, gameController.playerBoard)
		gameController.tilesBoats[shipTip["type"]].show()
		gameController.tilesBoats[shipTip["type"]].position = shipTip.position
		gameController.tilesBoats[shipTip["type"]].isSelected = true

func positionShip(tile,board):
	##Defines the tile for the selected boat
	#print(gameController.battleship)
	#print(gameController.carrier)
	print(gameController.destroyer)
	#print(gameController.patrolBoat)
	#print(gameController.submarine)
	print(gameController.selectedShip)
	var boatTile = gameController.boatsTiles[gameController.selectedShip]
	
	##Checks if boat is in vertical
	if(gameController.selectedShip.isVertical):
		
		##Checks if any parts are outside the board
		if(tile["y"] + gameController.shipSize[boatTile] <= gameController.gridSize) : 
			
			##Checks if positions are avaliable
			for n in range (0, gameController.shipSize[boatTile]) :
				if(board[Vector2(tile["x"],tile["y"]+n)]["type"] != 2) :
					return true
					
			##Updates positions					
			for n in range (0, gameController.shipSize[boatTile]) :
				set_cell(0, Vector2(tile["x"],tile["y"]+n), boatTile , Vector2i(0,0), 0) 	
				board[Vector2(tile["x"],tile["y"]+n)]["type"] = boatTile
				board[Vector2(tile["x"],tile["y"]+n)]["boat"] = boatTile
				board[Vector2(tile["x"],tile["y"]+n)]["vertical"] = true
				
			##Hides the node
			gameController.selectedShip.hide()
			
func selectTile(tile):	
		set_cell(1, tile, 9, Vector2i(0,0), 0)
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
		if(gameController.current_state == gameController.state.PREPARING) :
			if(Input.is_action_just_pressed("mb_left")):
				moveShip(tile)
			if(Input.is_action_just_pressed("mb_right")):
				rotateShip(tile, gameController.playerBoard)
			if(gameController.selectedShip != null and gameController.selectedShip.isReleased) :
				if(positionShip(tile, gameController.playerBoard)):
					gameController.selectedShip.position = gameController.selectedShip.lastAvaliablePosition				
				gameController.selectedShip = null	
	if gameController.enemyBoard.has(str(tile)):
		selectTile(tile)	
		if(Input.is_action_just_pressed("mb_left") && gameController.current_state == gameController.state.PLAYERTURN):
			attack(tile, gameController.enemyBoard)
