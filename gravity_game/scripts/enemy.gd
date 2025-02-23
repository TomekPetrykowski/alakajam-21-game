extends Area2D
class_name Enemy
@onready var player = %Player
@onready var lazer_path = preload("res://scenes/enemy_lazer.tscn")
var orbit_point = Vector2.ZERO : set = _changed_orbit
var SPEED = 50
var alpha = null
var radius = 20
var angry = false
var attack_delay = 1.0
var hp = 4 : set = _hp_changed
var planet = null


func _hp_changed(new):
	if planet!=null:
		planet.attacked = true
	if new<=0:
		Vars.ships_destroyed+=1
		queue_free()
	else:
		hp=new




func _process(delta: float) -> void:
	if not angry:
		if alpha==null:
			alpha = position.angle_to_point(orbit_point) + deg_to_rad(-180)
		orbit(delta)
	else:
		if orbit_point == Vector2.ZERO or position.distance_to(orbit_point)>radius+10 or player.rotation_point !=orbit_point:
			alpha = null
			look_at(player.position*2)
			position+=(player.position-position).normalized()*delta*SPEED
		else:
			if alpha==null:
				alpha = position.angle_to_point(orbit_point) + deg_to_rad(-180)
			orbit(delta)
		attack_delay-=delta
		if attack_delay<0:
			shoot()
			attack_delay=1.0
	
func orbit(delta):
	look_at(orbit_point*2)
	rotation+=deg_to_rad(-90)
	alpha+=delta
	position.y = orbit_point.y+sin(alpha)*radius
	position.x = orbit_point.x+cos(alpha)*radius

func shoot():
	var lazer = lazer_path.instantiate()
	lazer.direction = (player.position-position).normalized()
	lazer.position = position
	get_parent().add_child(lazer)

func _changed_orbit(new):
	orbit_point = new
	#alpha = position.angle_to_point(orbit_point) + deg_to_rad(-180)


func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		hp-=1
		#print("hit")
