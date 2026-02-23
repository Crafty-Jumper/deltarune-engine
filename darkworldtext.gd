@tool
extends RichTextEffect
class_name DarkWorldEffect

var bbcode: String = "dark"

func _process_custom_fx(char_fx: CharFXTransform) -> bool:
	var color := Color("#" + char_fx.env.get("color", "ffff00"))

	# glyph_uv.y goes from 0 (top) → 1 (bottom)
	var t = clamp(char_fx.glyph_uv.y, 0.0, 1.0)

	# Blend: top always white → bottom custom color
	char_fx.color.lerp(Color.WHITE,char_fx.glyph_index)

	return true
