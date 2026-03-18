@tool
extends RichTextEffect
class_name RichTextComicsans



# To use this effect:
# - Enable BBCode on a RichTextLabel.
# - Register this effect on the label.
# - Use [comicsans param=2.0]hello[/comicsans] in text.
var bbcode := "comicsans"


func _process_custom_fx(char_fx: CharFXTransform) -> bool:
	char_fx.set_font(load("res://textbox/comic.ttf"))
	return true
