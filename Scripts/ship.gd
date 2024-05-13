extends Node2D

@onready var ship = $Sprite2D
@onready var gameController = GameController

## Control Variables
var isVertical = false
var isSelected = false
var isReleased = false
var lastAvaliablePosition
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

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
		gameController.selectedShip = get_node(".")
		if Input.is_action_just_released("mb_left"):
			isSelected = false		
			isReleased = true
			
