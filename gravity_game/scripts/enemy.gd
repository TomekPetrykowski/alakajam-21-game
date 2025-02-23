extends Area2D
class_name Enemy
@onready var player = %Player
var orbit_point = Vector2.ZERO : set = _changed_orbit
var SPEED = 50
var chasing = false
var alpha = 0
var radius = 20
var destination = null
var angry = false



func _process(delta: float) -> void:
	if orbit_point == Vector2.ZERO or position.distance_to(orbit_point)>110:
		look_at(player.position*2)
		position+=(player.position-position).normalized()*delta*SPEED
	else:
		look_at(orbit_point*2)
		rotation+=deg_to_rad(-90)
		alpha+=delta
		position.y = orbit_point.y+sin(alpha)*radius
		position.x = orbit_point.x+cos(alpha)*radius
		
		

func _changed_orbit(new):
	orbit_point = new
	radius = 100
	alpha = position.angle_to_point(orbit_point) + deg_to_rad(-180)

	
