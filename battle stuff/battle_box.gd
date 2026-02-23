extends StaticBody2D

var tween

func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func animate_in() -> void:
	scale = Vector2.ZERO
	rotation_degrees = -180
	modulate = Color(1,1,1,0)
	tween = create_tween()
	tween.parallel().tween_property(self,"scale",Vector2(0.25,0.25),0.5)
	tween.parallel().tween_property(self,"rotation",0,0.5)
	tween.parallel().tween_property(self,"modulate",Color(1,1,1,1),0.5)
	show()

func animate_out() -> void:
	scale = Vector2(0.25,0.25)
	rotation = 0
	modulate = Color(1,1,1,1)
	tween = create_tween()
	tween.parallel().tween_property(self,"scale",Vector2.ZERO,0.5)
	tween.parallel().tween_property(self,"rotation_degrees",-180,0.5)
	tween.parallel().tween_property(self,"modulate",Color(1,1,1,0),0.5)
	show()
