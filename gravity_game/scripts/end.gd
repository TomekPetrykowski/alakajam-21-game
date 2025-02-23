extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Label.text = "Ships destroyed:"+str(Vars.ships_destroyed)+"\nHouses destroyed:"+str(Vars.houses_destroyed)+"\nTime taken:"+str(snapped(Vars.time,0.01))
	



func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/start.tscn")
