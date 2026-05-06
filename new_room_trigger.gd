extends Area2D
@export var event : int = 0
@export var room : String = "main.tscn"
@export_enum ("Room","Event") var mode = 0

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("kris"):
		if mode == 1:
			Global.callEvent(event)
		if mode == 0:
			Global.change_scene("res://scenes/" + room)
			Global.callEvent("DM")
