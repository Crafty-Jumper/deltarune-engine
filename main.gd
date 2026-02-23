extends Node2D

@onready var music: AudioStreamPlayer = $Camera/Music
signal battle
var battling: bool = false
@onready var timer: Timer = $Timer
@onready var BattleManager: Node2D = $BattleManager
var attacking: bool = false
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("c"):
		if not battling:
			battle.emit()

func changesong(path:String="music/battle.ogg",vol:float=0.0,pitch:float=1.0) -> void:
	music.stream = load("res://" + path)
	music.volume_db = vol
	music.pitch_scale = pitch
	music.play()

func fadesong() -> void:
	music.volume_linear = 0


func _on_battle() -> void:
	changesong("sounds/battlehorn.wav")
	timer.start(1)


func _on_timer_timeout() -> void:
	changesong()
	battling = true
	BattleManager.battle = true
