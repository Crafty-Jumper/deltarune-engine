extends CanvasLayer

# basic stuff
var canMove: bool = true
var frame: int = 0
signal textbox(id:int)
signal hide_textbox
signal battle

# event stuff
var cmndStr: String = ""
var EVENTS : Array = JSON.parse_string(FileAccess.open("res://events.json",FileAccess.READ).get_as_text())

# room transitions
var fadeAmnt : float = 0.0
var a = ColorRect.new()
var fadeIn : bool = false
var room : String = "res://scenes/main.tscn"

func _ready() -> void:
	add_child(a)
	a.color = Color(0,0,0,0.0)
	a.size.x = 1400
	a.size.y = 1400
	a.z_index = 4096

func _process(delta: float) -> void:
	frame += 60 * delta
	a.color.a = fadeAmnt
	fadeAmnt = clamp(fadeAmnt, 0, 1)
	if fadeIn:
		fadeAmnt += 0.05 * delta * 60
	else:
		fadeAmnt -= 0.05 * delta * 60
	if fadeAmnt >= 1.0:
		get_tree().change_scene_to_file(room)
		fadeIn = false
		canMove = true

func callEvent(event=0) -> void:
	if event is int:
		if event == 0:
			return
		cmndStr = EVENTS[event]
		for i in cmndStr.split(" "):
			handleCommand(i)
	else: if event is String:
		for i in event.split(" "):
			handleCommand(i)

func handleCommand(command:String="EM"):
	if command == "EM":
		canMove = true
	if command == "DM":
		canMove = false
	if command.substr(0,2) == "TB":
		textbox.emit(int(command.get_slice("TB",1)))
	if command == "CTB":
		hide_textbox.emit()
	if command == "BTL":
		battle.emit()
	if command.begins_with("RM("):
		change_scene("res://scenes/" + command.get_slice("(",1).replace(")",""))

func change_scene(path:String):
	fadeIn = true
	room = path
