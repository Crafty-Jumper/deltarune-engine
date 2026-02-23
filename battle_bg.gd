extends Sprite2D

var animationframe: float = 1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	@warning_ignore("narrowing_conversion")
	animationframe = fmod(animationframe,100)+1
	animationframe += 0.5
	texture = load("res://battle bg/BBS_" + str(int(floor(animationframe))) + ".png")
