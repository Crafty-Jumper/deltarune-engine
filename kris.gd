extends CharacterBody2D

@onready var sprite: Sprite2D = $Sprite2D

const SPEED = 50
var frame = 0
var timing = 20
var dir = 0
@export var frameoff = Vector2i(0,0)
var position_history: Array[Vector2] = []
var canMove: bool = true
@onready var battle_sprite: Sprite2D = $BattleSprite

# battle animations
@export_category("Textures")
@export var idleAnim: Texture = preload("res://battle stuff/battle sprites/kris/idle.png")
@export var attackAnim: Texture = preload("res://battle stuff/battle sprites/kris/attack.png")
@export var defendAnim: Texture = preload("res://battle stuff/battle sprites/kris/defend.png")
@export var itemAnim: Texture = preload("res://battle stuff/battle sprites/kris/item.png")
@export var endAnim: Texture = preload("res://battle stuff/battle sprites/kris/end.png")
@export var actAnim: Texture = preload("res://battle stuff/battle sprites/kris/act.png")
@export var prepAnim: Texture = preload("res://battle stuff/battle sprites/kris/prepare.png")
@export var painAnim: Texture = preload("res://battle stuff/battle sprites/kris/pain.png")
# ---------------------------
@export_category("Frames")
@export var idleFrames: int = 6
@export var attackFrames: int = 8
@export var defendFrames: int = 6
@export var itemFrames: int = 8
@export var endFrames: int = 9
@export var actFrames: int = 11
@export var prepFrames: int = 2
# ---------------------------
@export_category("Offsets")
@export var idleOff: Vector2 = Vector2(0.5,0)
@export var attackOff: Vector2 = Vector2(14,1)
@export var defendOff: Vector2 = Vector2(0,-1)
@export var itemOff: Vector2 = Vector2(14,1)
@export var endOff: Vector2 = Vector2(0,0)
@export var actOff: Vector2 = Vector2(7,-2)
@export var prepOff: Vector2 = Vector2(7,-2)
@export var hurtOff: Vector2 = Vector2(13.5,-2)
@export var downOff: Vector2 = Vector2(13.5,-2)
var currAnim: String = "attack"

func _physics_process(_delta: float) -> void:
	if get_parent().battling:
		handle_battle_sprites(currAnim)
		return
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
	

func handle_battle_sprites(animation:String="idle") -> void:
	timing -= 2
	battle_sprite.show()
	sprite.hide()
	if animation == "idle":
		if battle_sprite.texture != idleAnim:
			battle_sprite.texture = idleAnim
		battle_sprite.hframes = idleFrames
		battle_sprite.vframes = 1
		frame = fmod(frame,idleFrames)
		battle_sprite.frame = frame
		battle_sprite.offset = idleOff
		if timing <= 0:
			frame += 1
			timing = 10
	if animation == "attack":
		if battle_sprite.texture != attackAnim:
			battle_sprite.texture = attackAnim
			frame = 0
		battle_sprite.hframes = attackFrames
		battle_sprite.vframes = 1
		battle_sprite.frame = frame
		if timing <= 0:
			frame += 1
			timing = 5
		if frame == attackFrames + 5:
			currAnim = "idle"
		battle_sprite.offset = attackOff
	if animation == "prep":
		if battle_sprite.texture != prepAnim:
			battle_sprite.texture = prepAnim
		battle_sprite.hframes = prepFrames
		battle_sprite.vframes = 1
		frame = fmod(frame,prepFrames)
		battle_sprite.frame = frame
		battle_sprite.offset = Vector2.ZERO
		if timing <= 0:
			frame += 1
			timing = 10
		battle_sprite.offset = prepOff
	if animation == "act":
		if battle_sprite.texture != actAnim:
			battle_sprite.texture = actAnim
			frame = 0
		battle_sprite.hframes = actFrames
		battle_sprite.vframes = 1
		battle_sprite.frame = frame
		if timing <= 0:
			frame += 1
			timing = 5
		if frame == actFrames-1:
			currAnim = "idle"
		battle_sprite.offset = actOff
	if animation == "defend":
		if battle_sprite.texture != defendAnim:
			battle_sprite.texture = defendAnim
			frame = 0
		battle_sprite.hframes = defendFrames
		battle_sprite.vframes = 1
		battle_sprite.frame = frame
		if timing <= 0:
			frame += 1
			timing = 5
		battle_sprite.offset = defendOff
	if animation == "item":
		if battle_sprite.texture != itemAnim:
			battle_sprite.texture = itemAnim
			frame = 0
		battle_sprite.hframes = itemFrames
		battle_sprite.vframes = 1
		battle_sprite.frame = frame
		if timing <= 0:
			frame += 1
			timing = 5
		if frame == itemFrames:
			currAnim = "idle"
		battle_sprite.offset = itemOff
	if animation == "hurt":
		if battle_sprite.texture != painAnim:
			battle_sprite.texture = painAnim
			frame = 0
		battle_sprite.hframes = 2
		battle_sprite.vframes = 1
		battle_sprite.frame = 0
		if timing <= 0:
			frame += 1
			timing = 5
		if frame > 5:
			currAnim = "idle"
		battle_sprite.offset = hurtOff
	if animation == "down":
		if battle_sprite.texture != painAnim:
			battle_sprite.texture = painAnim
			frame = 0
		battle_sprite.hframes = 2
		battle_sprite.vframes = 1
		battle_sprite.frame = 1
		battle_sprite.offset = hurtOff
	if animation == "end":
		if battle_sprite.texture != endAnim:
			battle_sprite.texture = endAnim
			frame = 0
		battle_sprite.hframes = endFrames
		battle_sprite.vframes = 1
		battle_sprite.frame = frame
		if timing <= 0:
			frame += 1
			timing = 5
		if frame == endFrames:
			battle_sprite.hide()
			sprite.show()
		battle_sprite.offset = endOff
