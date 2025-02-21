extends AnimatableBody2D


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		body.rotation_point = position


#func _on_area_2d_body_exited(body: Node2D) -> void:
	#if body.name == "Player":
		#body.rotation_point = position
