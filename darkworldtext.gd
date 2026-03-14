@tool
extends RichTextEffect
class_name DarkWorldEffect

var bbcode: String = "dark"

func _process_custom_fx(char_fx: CharFXTransform) -> bool:
	var color := Color("#" + char_fx.env.get("color", "ffff00"))
	

	# Blend: top always white → bottom custom color
	char_fx.color.lerp(Color.WHITE,char_fx.glyph_index)

	return true
