extends Node2D

var battle: bool = false
var prevPos: Array[Vector2] = [Vector2(0,0),Vector2(0,0),Vector2(0,0)]
var battleTween
var tension: float = 0.0
var tpFillAmnt: float = 0.0
signal battleStart
signal attacking
const bullet = preload("uid://ddxvth8t8dlgx")

@onready var battle_box: StaticBody2D = $"BattleBox"
@onready var battle_bg: Sprite2D = $"BattleBG"
@onready var kris: CharacterBody2D = $"../SWORD"
@onready var susie: CharacterBody2D = $"../AX"
@onready var ralsei: CharacterBody2D = $"../SCARF"
@onready var timer: Timer = $Attack
@onready var soul: CharacterBody2D = $"Soul"
@onready var tp_bar: Sprite2D = $TPBar
@onready var tp_fill: Sprite2D = $TPBar/TpFill
@onready var Main: Node2D = $".."

func _process(_delta: float) -> void:
	tpFillAmnt = tension/100.0
	tp_fill.material.set_shader_parameter("fill", tension/100.0)
	if not battle:
		tp_bar.hide()
		return
	tp_bar.show()
	
	tension = clamp(tension,0.0,100.0)
	
	if Input.is_action_just_pressed("c"):
		attacking.emit()
	
	
	if battle_box.scale == Vector2(0.25,0.25) and battle_box.visible:
		soul.show()
		if randi_range(0,31) == 0:
			spawn_bullets()
		Main.attacking = true
	else:
		soul.hide()
		Main.attacking = false

func spawn_bullets() -> void:
	var targetPos = Vector2(randf_range(70,-70),randf_range(70,-70))
	var bull: Node2D = bullet.instantiate()
	bull.position = targetPos
	bull.scale = Vector2(0.25,0.25)
	add_child(bull)

func _on_battle_start() -> void:
	battleTween = create_tween()
	prevPos[0] = kris.global_position
	prevPos[1] = susie.global_position
	prevPos[2] = ralsei.global_position
	battleTween.parallel().tween_property(kris,"position",Vector2(-104,-69),0.5)
	battleTween.parallel().tween_property(susie,"position",Vector2(-104,-24.5),0.5)
	battleTween.parallel().tween_property(ralsei,"position",Vector2(-104,20),0.5)
	battleTween.parallel().tween_property(battle_bg,"modulate",Color(1,1,1,1),0.5)
	battle_bg.show()
	$"BattleBG/BattleBG2".show()

func _on_timer_timeout() -> void:
	battleStart.emit()

func _on_node_2d_battle() -> void:
	kris.canMove = false

func _on_attacking() -> void:
	battle_box.animate_in()
	timer.start()
	soul.position = Vector2.ZERO

func _on_attack_timeout() -> void:
	battle_box.animate_out()
