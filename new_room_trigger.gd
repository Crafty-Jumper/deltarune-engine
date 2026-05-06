extends Area2D
@export var room : String = ""


func _on_body_entered(body: Node2D) -> void:
	Global.change_scene("res://scenes/" + room)
