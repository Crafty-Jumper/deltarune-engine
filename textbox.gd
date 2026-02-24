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

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	
	#if Input.is_action_just_pressed("c"):
	#	get_textbox(textboxId)
		
	
	
	frameCounter += 1
	if waitForInp:
		if Input.is_action_just_pressed("z"):
			waitForInp = false
			if remainMsg == "":
				msgIdx += 1
				if textboxSet.get(msgIdx) is String:
					get_textbox(textboxId)
				else:
					kill_textbox()
					
		return
	else:
		if remainMsg == "":
			get_textbox_sub(textboxId)
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
	

func get_textbox(id:int=0):
	subplot.hide()
	rich_text_label.text = ""
	remainMsg = textbox[id]["texts"][msgIdx]
	textboxSet = textbox[id]["texts"]
	show()
	waitForInp = false
	if FileAccess.file_exists("res://textbox/" + textbox[id]["speakers"][msgIdx] + "/" + str(int(textbox[id]["faces"][msgIdx])) + ".png"):
		sprite_2d.show()
		rich_text_label.position.x = -72.5
		rich_text_label.size.x = 213.0
		sprite_2d.texture = load("res://textbox/" + textbox[id]["speakers"][msgIdx] + "/" + str(int(textbox[id]["faces"][msgIdx])) + ".png")
	else:
		sprite_2d.hide()
		rich_text_label.position.x = -130.5
		rich_text_label.size.x = 271.0

func addLetter():
	if fmod(frameCounter,2) == 0:
		return
	
	var character = remainMsg.substr(0,1)
	if character == "\n":
		for i in remainMsg:
			rich_text_label.text += character
			remainMsg = remainMsg.erase(0)
			character = remainMsg.substr(0,1)
			if character != " ":
				break
			
	
	if character == "^":
		remainMsg = remainMsg.erase(0)
		character = remainMsg.substr(0,1)
		remainMsg = remainMsg.erase(0)
		if character == "Y":
			rich_text_label.text += "[color=ff0]"
		if character == "G":
			rich_text_label.text += "[color=0f0]"
		if character == "R":
			rich_text_label.text += "[color=f00]"
		if character == "O":
			rich_text_label.text += "[color=f70]"
		if character == "B":
			rich_text_label.text += "[color=00f]"
		if character == "P":
			rich_text_label.text += "[color=70f]"
		if character == "M":
			rich_text_label.text += "[color=f0f]"
		if character == "W":
			rich_text_label.text += "[/color]"
		if character == "S":
			rich_text_label.text += "[shake connected=1]"
		if character == "s":
			rich_text_label.text += "[/shake]"
		if character == "L":
			rich_text_label.text += "[color=7f0]"
		character = remainMsg.substr(0,1)
	if  character == "/":
		waitForInp = true
		remainMsg = remainMsg.erase(0)
		return
	if character == "_":
		remainMsg = remainMsg.erase(0)
		return
	rich_text_label.text += character
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
