extends Node2D

@onready var ship = $Sprite2D

## Control Variables
var isVertical 
var isSelected 
var isReleased 
var lastAvaliablePosition
# Called when the node enters the scene tree for the first time.
func _ready():
	isVertical = false
	isSelected = false
	isReleased = false
	lastAvaliablePosition = position

func _input(event):
	if(ship.get_rect().has_point(to_local(event.position))):
		if(event.is_action_pressed("mb_left")): 
			lastAvaliablePosition = position
			isSelected = true
			isReleased = false
		if(event.is_action_pressed("mb_right")):
			if(isVertical == false) :
				ship.rotate(PI/2)
				isVertical = true
			else :
				ship.rotate(-PI/2)
				isVertical = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if isSelected :		
		position = get_viewport().get_mouse_position()
		GameController.selectedShip = get_node(get_path())		
		if Input.is_action_just_released("mb_left"):
			isSelected = false		
			isReleased = true
			
