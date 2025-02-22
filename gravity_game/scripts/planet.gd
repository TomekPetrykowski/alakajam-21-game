extends AnimatableBody2D


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		body.rotating_around = self


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "Player" and body.rotation_point == position:
		body.rotating_around = null


#func _physics_process(delta: float) -> void:
	#position.x+=1
