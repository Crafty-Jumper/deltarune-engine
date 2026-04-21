extends Node

# basic stuff
var canMove: bool = true
var frame: int = 0
signal textbox(id:int)
signal hide_textbox
signal battle

# event stuff
var cmndStr: String = ""
var EVENTS = JSON.parse_string(FileAccess.open("res://events.json",FileAccess.READ).get_as_text())

func _process(delta: float) -> void:
	frame += 60 * delta
	if Input.is_action_just_pressed("c"):
		callEvent(1)

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
