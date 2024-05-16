extends TileMap

##Var for selecting a tile in board
var tile = null
var aux = null

# Called when the node enters the scene tree for the first time.
func _ready(): 		
	## Setting up Player Board
	for x in GameController.gridSize:
		for y in GameController.gridSize:
			GameController.playerBoard[str(Vector2(x,y))] = {
					"type": 2 ,
					"x" : x,
					"y" : y,
					"vertical" : false,
					"boat" : -1
					
			}
			set_cell(0, Vector2(x,y), 2 , Vector2i(0,0), 0) 
			set_cell(1, Vector2(x,y), 8 , Vector2i(0,0), 0) 
			
	## Setting up Enemy Board
	for x in range(GameController.gridSize + GameController.gridDistance, 2* GameController.gridSize + GameController.gridDistance) : 
		for y in GameController.gridSize: 
			GameController.enemyBoard[str(Vector2(x,y))] = {
					"type": 2 ,
					"x" : x,
					"y" : y,
					"vertical" : false,
					"boat" : -1
					
			}
			set_cell(0, Vector2(x,y), 2 , Vector2i(0,0), 0) 
			set_cell(1, Vector2(x,y), 8 , Vector2i(0,0), 0) 
			
	##Setting up ships nodes on Game Controller
	GameController.battleship = $Battleship
	GameController.patrolBoat = $PatrolBoat
	GameController.submarine = $Submarine
	GameController.destroyer = $Destroyer
	GameController.carrier = $Carrier
	
	##Setting up dictionaries for functions 
	GameController.tilesBoats = {
		3 : GameController.battleship,
		4 : GameController.carrier,
		5 : GameController.destroyer,
		6 : GameController.patrolBoat,
		7 : GameController.submarine
	}
	GameController.boatsTiles = {
		GameController.battleship : 3,
		GameController.carrier : 4,
		GameController.destroyer : 5,
		GameController.patrolBoat : 6,
		GameController.submarine : 7
	}

func locateShipTip(tile, board): 
	var shipTip 	
	for boardTile in board :
		if board[str(boardTile)]["boat"] == board[str(tile)]["boat"] : 
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
			for n in range (1, GameController.shipSize[shipTip["type"]]) : 
				if board[str(Vector2(shipTip["x"]+n,shipTip["y"]))]["type"] > 2 :
					return
			
			##Updating positions
			for n in range (1, GameController.shipSize[shipTip["type"]]) : 
				
				##Occupying new positions
				set_cell(0, Vector2(shipTip["x"]+n,shipTip["y"]), shipTip["type"] , Vector2i(0,0), 0) 	
				board[str(Vector2(shipTip["x"]+n,shipTip["y"]))]["type"] = shipTip["type"]
				board[str(Vector2(shipTip["x"]+n,shipTip["y"]))]["boat"] = shipTip["boat"]
				board[str(Vector2(shipTip["x"]+n,shipTip["y"]))]["vertical"] = false
				
				##Clearing old positions
				set_cell(0, Vector2(shipTip["x"],shipTip["y"]+n), 2 , Vector2i(0,0), 0)
				board[Vector2(shipTip["x"],shipTip["y"]+n)]["type"] = 2
				board[Vector2(shipTip["x"],shipTip["y"]+n)]["boat"] = -1
				board[Vector2(shipTip["x"],shipTip["y"]+n)]["vertical"] = false
				
		else : 
			
			##Checking if the new position are unoccupied
			for n in range (1, GameController.shipSize[shipTip["type"]]) : 
				if board[str(Vector2(shipTip["x"],shipTip["y"]+n))]["type"] > 2 :
					return
					
			##Updating positions
			for n in range (1, GameController.shipSize[shipTip["type"]]) : 
				
				##Occupying new positions
				set_cell(0, Vector2(shipTip["x"],shipTip["y"]+n), shipTip["type"] , Vector2i(0,0), 0) 	
				board[str(Vector2(shipTip["x"],shipTip["y"]+n))]["type"] = shipTip["type"]
				board[str(Vector2(shipTip["x"],shipTip["y"]+n))]["boat"] =  shipTip["boat"]
				board[str(Vector2(shipTip["x"],shipTip["y"]+n))]["vertical"] = true
				
				##Clearing old positions
				set_cell(0, Vector2(shipTip["x"]+n,shipTip["y"]), 2 , Vector2i(0,0), 0)
				board[Vector2(shipTip["x"]+n,shipTip["y"])]["type"] = 2
				board[Vector2(shipTip["x"]+n,shipTip["y"])]["boat"] = -1
				board[Vector2(shipTip["x"]+n,shipTip["y"])]["vertical"] = false
			
			GameController.selectedShip._rotate_ship()

func moveShip(tile): 
	##Checks if the tile has a boat
	if(GameController.playerBoard[str(tile)]["type"] > 2):
		
		##Shows nad positions the selected boat into the clicked space
		var shipTip = locateShipTip(tile, GameController.playerBoard)
		GameController.tilesBoats[GameController.playerBoard[str(shipTip)]["type"]].show()		
		GameController.tilesBoats[GameController.playerBoard[str(shipTip)]["type"]].isSelected = true

func positionShip(tile,board):
	##Defines the tile for the selected boat	
	var boatTile = GameController.boatsTiles[GameController.selectedShip]	
	
	##Defines the last position the boat was
	var lastPosition = local_to_map(GameController.selectedShip.lastAvaliablePosition)	
										
	##Checks if boat is in vertical
	if(GameController.selectedShip.isVertical):
				
		##Checks if any parts are outside the board
		if(tile["y"] + GameController.shipSize[boatTile] <= GameController.gridSize) : 
			
			##Checks if positions are avaliable
			for n in range (GameController.shipSize[boatTile]) :	
				if(board[str(Vector2(tile["x"],tile["y"]+n))]["type"] != 2) :
					return false
					
			##Updates positions					
			for n in range (GameController.shipSize[boatTile]) :						
				set_cell(0, Vector2(tile["x"],tile["y"]+n), boatTile , Vector2i(0,0), 0) 	
				board[str(Vector2(tile["x"],tile["y"]+n))]["type"] = boatTile
				board[str(Vector2(tile["x"],tile["y"]+n))]["boat"] = boatTile
				board[str(Vector2(tile["x"],tile["y"]+n))]["vertical"] = true
				
			##Checks if boat was already in the board	
			if(GameController.playerBoard.has(str(lastPosition))) :
				
				##Clears the last positions
				for n in range(GameController.shipSize[boatTile]) :
					set_cell(0, Vector2(lastPosition.x,lastPosition.y+n), 2 , Vector2i(0,0), 0)	
					board[str(Vector2(lastPosition.x,lastPosition.y+n))]["type"] = 2							
					board[str(Vector2(lastPosition.x,lastPosition.y+n))]["boat"] = -1
				
			return true
	else :
		
		##Checks if any parts are outside the board
		if(tile["x"] + GameController.shipSize[boatTile] <= GameController.gridSize) : 
			
			for n in range (GameController.shipSize[boatTile]) :
				if(board[str(Vector2(tile["x"]+n,tile["y"]))]["type"] != 2) :
					return false
					
			##Updates positions					
			for n in range (GameController.shipSize[boatTile]) :
				set_cell(0, Vector2(tile["x"]+n,tile["y"]), boatTile , Vector2i(0,0), 0) 	
				board[str(Vector2(tile["x"]+n,tile["y"]))]["type"] = boatTile
				board[str(Vector2(tile["x"]+n,tile["y"]))]["boat"] = boatTile
				
			##Checks if boat was already in the board	
			if(GameController.playerBoard.has(str(lastPosition))) :	
				
			##Clears the last positions
				for n in range(GameController.shipSize[boatTile]) :
					set_cell(0, Vector2(lastPosition.x+n,lastPosition.y), 2 , Vector2i(0,0), 0)	
					board[str(Vector2(lastPosition.x+n,lastPosition.y))]["type"] = 2							
					board[str(Vector2(lastPosition.x+n,lastPosition.y))]["boat"] = -1
				
			return true	
					
	return false
			
func selectTile(tile):	
		set_cell(1, tile, 9, Vector2i(0,0), 0)
		aux = tile
		
func setupGame():
	GameController.playerBoard.clear()
	GameController.enemyBoard.clear()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):		
	tile = local_to_map(get_global_mouse_position())
	if aux != null :
			set_cell(1, aux, 8, Vector2i(0,0), 0)
	if GameController.playerBoard.has(str(tile)):
		selectTile(tile)	
		if(GameController.current_state == GameController.state.PREPARING) :
			if(Input.is_action_just_pressed("mb_left")):
				moveShip(tile)
			if(Input.is_action_just_pressed("mb_right")):
				rotateShip(tile, GameController.playerBoard)
			if(GameController.selectedShip != null and GameController.selectedShip.isReleased) :
				if(positionShip(tile, GameController.playerBoard)):	
					GameController.selectedShip.lastAvaliablePosition = map_to_local(Vector2i(tile["x"],tile["y"]))
					GameController.selectedShip.position = GameController.selectedShip.lastAvaliablePosition
					GameController.selectedShip.hide()
				else:
					GameController.selectedShip.position = GameController.selectedShip.lastAvaliablePosition				
				GameController.selectedShip = null	
	if GameController.enemyBoard.has(str(tile)):
		selectTile(tile)	
		if(Input.is_action_just_pressed("mb_left") && GameController.current_state == GameController.state.PLAYERTURN):
			attack(tile, GameController.enemyBoard)
