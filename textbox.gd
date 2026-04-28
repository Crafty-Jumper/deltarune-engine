extends Sprite2D

var textbox: Array = JSON.parse_string(FileAccess.open("res://textbox/textbox.json",FileAccess.READ).get_as_text())
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
var msgIdx: int = 0
var remainMsg: String = ""
var textboxSet: Array = []
@onready var rich_text_label: RichTextLabel = $RichTextLabel
@onready var sprite_2d: Sprite2D = $Sprite2D
var waitForInp: bool = true
var frameCounter:int = 0
var textboxId: int = 2
@onready var subplot: Sprite2D = $Subplot
@onready var subtext: RichTextLabel = $Subplot/Subtext
var subplotTween
var darkworld: bool = false
const audibleLetters:Array[String] = [
	"A","B","C","D","E","F","G","H","I","J","K","L","M",
	"N","O","P","Q","R","S","T","U","V","W","X","Y","Z",
	"a","b","c","d","e","f","g","h","i","j","k","l","m",
	"n","o","p","q","r","s","t","u","v","w","x","y","z",
	".",",","!","?"
]
var choosing: bool = false
var choice: int = 0
@onready var choices_node: Node2D = $Choices

@onready var _1: RichTextLabel = $"Choices/1"
@onready var _2: RichTextLabel = $"Choices/2"
@onready var _3: RichTextLabel = $"Choices/3"
@onready var _4: RichTextLabel = $"Choices/4"
var writingChoice: int = 0
var choiceName: String = ""

func _ready() -> void:
	Global.textbox.connect(get_textbox)
	Global.hide_textbox.connect(kill_textbox)

func _process(_delta: float) -> void:
	if !visible:
		return
		
	if choices_node.visible:
		if Input.is_action_just_pressed("left"):
			if _1.text != "":
				choice = 1
		if Input.is_action_just_pressed("right"):
			if _2.text != "":
				choice = 2
		if Input.is_action_just_pressed("up"):
			if _3.text != "":
				choice = 3
		if Input.is_action_just_pressed("down"):
			if _4.text != "":
				choice = 4
	
	_1.modulate = Color.WHITE
	_2.modulate = Color.WHITE
	_3.modulate = Color.WHITE
	_4.modulate = Color.WHITE
	
	if choice == 1:
		_1.modulate = Color.YELLOW
	if choice == 2:
		_2.modulate = Color.YELLOW
	if choice == 3:
		_3.modulate = Color.YELLOW
	if choice == 4:
		_4.modulate = Color.YELLOW
	
	frameCounter += 1
	
	if waitForInp:
		if Input.is_action_just_pressed("z"):
			waitForInp = false
			if remainMsg.length() > 1:
				return
			if textboxSet.size()-1 > msgIdx:
				msgIdx += 1
				get_textbox(textboxId)
			else:
				waitForInp = true
				Global.callEvent(int(textbox[textboxId].get("endevent")))
		return
	else:
		if remainMsg == "":
			get_textbox_sub(textboxId)
	if choosing:
		write_to_choice()
	else:
		addLetter()
	

func get_textbox_sub(id:int=0):
	tweenSubplot()
	msgIdx += 1
	subtext.text = textbox[id]["texts"][msgIdx]
	textboxSet = textbox[id]["texts"]
	subplot.show()
	waitForInp = true
	if FileAccess.file_exists("res://textbox/" + textbox[id]["speakers"][msgIdx] + "/" + str(int(textbox[id]["faces"][msgIdx])) + ".png"):
		subplot.show()
		subplot.texture = load("res://textbox/" + textbox[id]["speakers"][msgIdx] + "/" + str(int(textbox[id]["faces"][msgIdx])) + ".png")

func write_to_choice() -> void:
	if fmod(frameCounter,2) == 0:
		return
	if choiceName == "":
		if writingChoice > 0:
			if textboxSet[msgIdx].get(writingChoice-1) is String:
				choiceName = textboxSet[msgIdx].get(writingChoice-1)
	var currNode = rich_text_label
	if writingChoice == 1:
		currNode = _1
	if writingChoice == 2:
		currNode = _2
	if writingChoice == 3:
		currNode = _3
	if writingChoice == 4:
		currNode = _4
	
	var character = choiceName.substr(0,1)
	currNode.append_text(character)
	choiceName = choiceName.erase(0)
	
	if audibleLetters.has(character):
		var path = "res://textbox/sounds/snd_" + textbox[textboxId]["talksounds"][msgIdx] + ".wav"
		if FileAccess.file_exists(path):
			audio_stream_player.stream.set_stream(0,load(path))
			for i in 10:
				audio_stream_player.stream.set_stream_probability_weight(i,0)
			audio_stream_player.stream.set_stream_probability_weight(0,1)
		else:
			load_randomized_sounds()
		audio_stream_player.play()
	if choiceName == "":
		if writingChoice < textboxSet[msgIdx].size() and writingChoice != 0:
			writingChoice += 1
		else:
			writingChoice = 0
			choosing = false

func show_choices() -> void:
	choice = 0
	writingChoice = 1
	_1.text = ""
	_2.text = ""
	_3.text = ""
	_4.text = ""
	remainMsg = "/"
	show()
	choosing = true
	rich_text_label.hide()
	choices_node.show()
	sprite_2d.hide()
	return

func get_textbox(id:int=0):
	if textboxId != id:
		msgIdx = 0
	textboxId = id
	choices_node.hide()
	rich_text_label.show()
	subplot.hide()
	rich_text_label.text = ""
	if textbox[id]["speakers"][msgIdx] == "choice":
		show_choices()
		return
	remainMsg = textbox[id]["texts"][msgIdx]
	textboxSet = textbox[id]["texts"]
	show()
	waitForInp = false
	choosing = false
	if FileAccess.file_exists("res://textbox/" + textbox[id]["speakers"][msgIdx] + "/" + str(int(textbox[id]["faces"][msgIdx])) + ".png"):
		sprite_2d.show()
		rich_text_label.position.x = -72.5
		rich_text_label.size.x = 213.0
		sprite_2d.texture = load("res://textbox/" + textbox[id]["speakers"][msgIdx] + "/" + str(int(textbox[id]["faces"][msgIdx])) + ".png")
	else:
		sprite_2d.hide()
		rich_text_label.position.x = -130.5
		rich_text_label.size.x = 271.0

func addLetter(label:RichTextLabel=rich_text_label):
	if fmod(frameCounter,2) == 0:
		return
	
	var character = remainMsg.substr(0,1)
	if character == "\n":
		for i in remainMsg:
			label.append_text(character)
			remainMsg = remainMsg.erase(0)
			character = remainMsg.substr(0,1)
			if character != " ":
				break
	
	# Text Formatting
	if character == "^":
		remainMsg = remainMsg.erase(0)
		character = remainMsg.substr(0,1)
		remainMsg = remainMsg.erase(0)
		
		if character == "c":
			label.append_text("[font=\"res://textbox/comic.ttf\"]")
		if character == "C":
			label.append_text("[/font]")
		if character == "Y":
			label.append_text("[color=ff0]")
		if character == "G":
			label.append_text("[color=0f0]")
		if character == "R":
			label.append_text("[color=f00]")
		if character == "O":
			label.append_text("[color=f70]")
		if character == "B":
			label.append_text("[color=00f]")
		if character == "P":
			label.append_text("[color=70f]")
		if character == "M":
			label.append_text("[color=f0f]")
		if character == "W":
			label.append_text("[/color]")
		if character == "S":
			label.append_text("[shake connected=1]")
		if character == "s":
			label.append_text("[/shake]")
		if character == "L":
			label.append_text("[color=7f0]")
		character = remainMsg.substr(0,1)
	if  character == "/":
		waitForInp = true
		remainMsg = remainMsg.erase(0)
		return
	if character == "_":
		remainMsg = remainMsg.erase(0)
		return
	if character == "{":
		remainMsg = remainMsg.erase(0)
		var imagename: String = remainMsg.get_slice(",",0)
		remainMsg = remainMsg.replace(imagename,"").replace(",","")
		label.add_image(load("res://textbox/images/"+imagename),0,30)
		for i in 10:
			audio_stream_player.stream.set_stream_probability_weight(i,0)
		audio_stream_player.stream.set_stream(0,load("res://textbox/sounds/" + remainMsg.get_slice("}",0)))
		audio_stream_player.stream.set_stream_probability_weight(0,1)
		remainMsg = remainMsg.replace(remainMsg.get_slice("}",0),"").replace("}","")
		audio_stream_player.play()
		return
	label.append_text(character)
	remainMsg = remainMsg.erase(0)
	if audibleLetters.has(character):
		var path = "res://textbox/sounds/snd_" + textbox[textboxId]["talksounds"][msgIdx] + ".wav"
		if FileAccess.file_exists(path):
			audio_stream_player.stream.set_stream(0,load(path))
			for i in 10:
				audio_stream_player.stream.set_stream_probability_weight(i,0)
			audio_stream_player.stream.set_stream_probability_weight(0,1)
		else:
			load_randomized_sounds()
		audio_stream_player.play()

func kill_textbox() -> void:
	waitForInp = true
	hide()
	rich_text_label.text = ""
	msgIdx = 0

func tweenSubplot() -> void:
	subplot.position.x += 10
	subplot.modulate = Color(1,1,1,0)
	subplotTween = create_tween()
	subplotTween.parallel().tween_property(subplot,"modulate",Color(1,1,1,1),0.2)
	subplotTween.parallel().tween_property(subplot,"position",Vector2(56,19),0.2)
	subplotTween.play()

func load_randomized_sounds(path:String="res://textbox/sounds/tv_voice_short/"):
	for i in 10:
		if FileAccess.file_exists(path + str(i) + ".wav"):
			audio_stream_player.stream.set_stream(i,load(path + str(i) + ".wav"))
			audio_stream_player.stream.set_stream_probability_weight(i,1)
		else:
			audio_stream_player.stream.set_stream_probability_weight(i,0)
