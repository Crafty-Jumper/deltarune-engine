extends CharacterBody2D

@onready var sprite: Sprite2D = $Sprite2D

const SPEED = 50
var frame = 0
var timing = 20
var dir = 0
@export var frameoff = Vector2i(0,0)
var position_history: Array[Vector2] = []
var canMove: bool = true

func _physics_process(delta: float) -> void:
	
	timing -= (2 if Input.is_action_pressed("x") else 1)
	
	var direction := Vector2(Input.get_axis("left", "right"),Input.get_axis("up","down")) * int(canMove)
	if direction:
		velocity = direction * SPEED * (2.0 if Input.is_action_pressed("x") else 1.0)
		if timing <= 0:
			frame += 1
			timing = 20
	else:
		velocity = Vector2(0,0)
		frame = 0
	if direction.x == 1:
		dir = 2
	if direction.x == -1:
		dir = 1
	if direction.y == 1:
		dir = 0
	if direction.y == -1:
		dir = 3
	
	frame = fmod(frame,4)
	
	sprite.frame_coords.x = frame
	sprite.frame_coords.y = dir
	sprite.frame_coords += frameoff
	move_and_slide()
