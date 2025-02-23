extends Node

var houses_destroyed = 0
var ships_destroyed = 0
var time = 0.0

func _process(delta: float) -> void:
	time += delta
