extends Area2D
class_name Enemy
@onready var player = %Player
var orbit_point = Vector2.ZERO : set = _changed_orbit
var SPEED = 30
var chasing = false
var alpha = 0
var radius = 20
var destination = null
var angry = false



#func _ready() -> void:
	#radius = position.distance_to(orbit_point)
	#alpha = position.angle_to(orbit_point)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if orbit_point == Vector2.ZERO or position.distance_to(orbit_point)>110:
		#print(position.distance_to(orbit_point))
		look_at(player.position*2)
		position+=(player.position-position).normalized()*delta*SPEED
	else:
		look_at(orbit_point*2)
		alpha+=delta
		#print(alpha)
		position.y = orbit_point.y+sin(alpha)*radius
		position.x = orbit_point.x+cos(alpha)*radius
		#print(get_global_mouse_position())
		#look_at(get_global_mouse_position())
		
		

func _changed_orbit(new):
	orbit_point = new
	#print(orbit_point)
	#radius = position.distance_to(orbit_point)
	radius = 100
	alpha = position.angle_to_point(orbit_point) + deg_to_rad(-180)
	#alpha = deg_to_rad(-90)

	
