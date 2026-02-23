extends CharacterBody2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var tp: Sprite2D = $Tp
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var BattleManager: Node2D = $".."
@onready var soul: Sprite2D = $Soul

const SPEED = 25
var canMove: bool = true
var mode:int = 0
enum SoulMode{RED,BLUE,GREEN,YELLOW,PURPLE}
var direction: Vector2 = Vector2(0,0)
const grav = 5.0
var jumpFrames = 20
const jumpFrameCount = 20


func _physics_process(delta: float) -> void:
	if tp.modulate.a > 0:
		tp.modulate.a -= 0.05
	
	direction = Vector2(Input.get_axis("left", "right"),Input.get_axis("up","down")) * int(canMove)
	match mode:
		SoulMode.RED:
			update_red()
		SoulMode.BLUE:
			update_blue()
		SoulMode.GREEN:
			update_green()
		SoulMode.YELLOW:
			update_yellow()
		SoulMode.PURPLE:
			update_purple()
	
	if Input.is_action_just_pressed("x"):
		mode += 1
	if Input.is_action_just_pressed("z"):
		mode -= 1
	
	move_and_slide()

func update_red() -> void:
	
	if direction:
		velocity = direction * SPEED * (1.0 if Input.is_action_pressed("x") else 2.0)
	else:
		velocity = Vector2(0,0)
	soul.self_modulate = Color.RED

func update_blue() -> void:
	soul.self_modulate = Color.BLUE
	if direction.x:
		velocity.x = direction.x * SPEED * (1.0 if Input.is_action_pressed("x") else 2.0)
	else:
		velocity.x = 0
	
	velocity.y += grav
	
	if direction.y < 0:
		if jumpFrames > 0:
			velocity.y = -grav * 12
			jumpFrames -= 1
	else:
		jumpFrames = 0
	
	if is_on_floor():
		jumpFrames = jumpFrameCount
	

func update_green() -> void:
	soul.self_modulate = Color.GREEN

func update_yellow() -> void:
	soul.self_modulate = Color.YELLOW

func update_purple() -> void:
	soul.self_modulate = Color.PURPLE


func _on_area_2d_body_entered(body: Node2D) -> void:
	if !body.is_in_group("bullet"):
		return
	
	BattleManager.tension += 1.0
	
	tp.modulate.a = 1
	audio_stream_player.play()
