extends Control

func _on_button_pressed() -> void:
	Vars.houses_destroyed = 0
	Vars.time = 0.0
	Vars.ships_destroyed = 0
	get_tree().change_scene_to_file("res://scenes/test_level.tscn")
