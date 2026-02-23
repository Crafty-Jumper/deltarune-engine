extends CharacterBody2D

@onready var sprite: Sprite2D = $Sprite2D
@export var leader: CharacterBody2D = null
@export var spritesheet: Texture
@export var delay: int = 30
@export var frameoff: Vector2i = Vector2i(0,0)
@export var spriteoff: Vector2 = Vector2(0,0)
var position_history: Array[Vector2] = []
var frame: int = 0
var timing: int = 20
var dir: int = 0
var poschange: Vector2 = Vector2(0,0)

func _ready() -> void:
	position_history.resize(delay)
	sprite.position += spriteoff
	resetpos()
	if spritesheet:
		sprite.texture = spritesheet

func _physics_process(_delta):
	var prevPos: Vector2 = global_position
	if leader.velocity:
		position_history.push_front(leader.global_position)
		global_position = position_history.get(delay)
		velocity = leader.velocity
	else:
		velocity = Vector2(0,0)
	if position_history.size() > delay:
		position_history.pop_back()
	poschange = global_position-prevPos
	updateAnim()

func updateAnim() -> void:
	timing -= (2 if (abs(poschange.x) > 1.3 or abs(poschange.y) > 1.3) else 1)
	
	if timing <= 0:
		frame += 1
		timing = 20
	if poschange != Vector2(0,0):
		frame = fmod(frame,4)
	else:
		frame = 0
	
	sprite.frame_coords.x = frame
	sprite.frame_coords.y = dir
	sprite.frame_coords += frameoff
	
	if round(poschange.x) > 0:
		dir = 2
	if round(poschange.x) < 0:
		dir = 1
	if round(poschange.y) > 0:
		dir = 0
	if round(poschange.y) < 0:
		dir = 3

func resetpos() -> void:
	var dist: Vector2 = (global_position - leader.global_position)
	for i in delay:
		position_history[i] = global_position + dist*(Vector2(i,i)/delay) - dist
