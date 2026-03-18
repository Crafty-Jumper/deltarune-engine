extends CharacterBody2D

var poschange: Vector2 = Vector2(0,0)
var frame: int = 0
var timing: int = 20
var dir: int = 0
@onready var sprite: Sprite2D = $Sprite2D
@export var interactionEvent: int = 0
@onready var area_2d: Area2D = $Area2D
@onready var area_2d_2: Area2D = $Area2D2
var interacted: bool = false

func _process(delta: float) -> void:
	var prevPos: Vector2 = global_position
	
	for node in area_2d.get_overlapping_bodies():
		if node.is_in_group("kris"):
			if Input.is_action_just_pressed("z") and !interacted:
				interacted = true
				Global.callEvent(interactionEvent)
				if node.position.x < position.x:
					dir = 1
				else:
					dir = 2
	
	for node in area_2d_2.get_overlapping_bodies():
		if node.is_in_group("kris"):
			if Input.is_action_just_pressed("z") and !interacted:
				interacted = true
				Global.callEvent(interactionEvent)
				if node.position.y < position.y:
					dir = 3
				else:
					dir = 0
	
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
	
	if round(poschange.x) > 0:
		dir = 2
	if round(poschange.x) < 0:
		dir = 1
	if round(poschange.y) > 0:
		dir = 0
	if round(poschange.y) < 0:
		dir = 3


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("kris"):
		interacted = false


func _on_area_2d_2_body_exited(body: Node2D) -> void:
	if body.is_in_group("kris"):
		interacted = false
