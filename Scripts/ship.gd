extends Node2D

@onready var ship = $Sprite2D


var isSelected = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _input(event):
	if event.is_action_pressed("mb_left") and ship.get_rect().has_point(to_local(event.position)): 
		isSelected = true
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if isSelected :		
		position = get_viewport().get_mouse_position()
		if Input.is_action_just_released("mb_left"):
			isSelected = false			
