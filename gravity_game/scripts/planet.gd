extends AnimatableBody2D

var ships = []
var attacked = false : set = _attacked_changed


func _attacked_changed(new):
	if new and not attacked:
		attacked = true
		for i in ships:
			i.angry = true




func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		body.rotating_around = self
		self.attacked = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "Player" and body.rotation_point == position:
		body.rotating_around = null


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area is Enemy:
		if not attacked:
			ships.append(area)
		area.orbit_point = position
		area.radius = $CollisionShape2D.shape.radius *2
		area.planet = self
