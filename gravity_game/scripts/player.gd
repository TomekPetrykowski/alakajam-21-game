extends CharacterBody2D


#@onready var planet = $"../StaticBody2D"
@onready var fuel_label = $Fuel

const SPEED = 300.0
const JUMP_VELOCITY = -300.0

var stable = false
var vector2planet = Vector2.ZERO
var jump_power = 0
var vertical = 0
var horizontal = 0
var jetpack_movement = Vector2.ZERO
var planet_movement = Vector2.ZERO
var movement = Vector2.ZERO
var jetpacking = false

var vector_rotation = 0
var rotation_point = Vector2.ZERO
var fuel = 3.0 :set = _change_fuel
var prev_vector = Vector2.ZERO
var planet_pull = 0
var rotating_around = null :set = _changed_rotating_around
var pointing_to = Vector2(-1,0)

func _physics_process(delta: float) -> void:
	if rotating_around != null:
		rotation_point = rotating_around.position
	pointing_to = Vector2(-1,0).rotated(rotation)
	if rotation_point != Vector2.ZERO:
		up_direction = vector2planet*-1
		vector_rotation = position.angle_to_point(rotation_point)
		vector2planet = (rotation_point - position).normalized()
		
		if stable:
			planet_movement.y += 10
			rotation = vector_rotation
		else:
			jetpack_movement += 10 * vector2planet
	jetpack_movement*=0.99
	
	if is_on_floor():
		stable = true
		jetpack_movement = Vector2.ZERO
		self.fuel += delta*2
	if Input.is_action_just_pressed("ui_accept"):
		if is_on_floor():
			planet_movement.y = JUMP_VELOCITY
		elif fuel >= 0.0:
			jetpacking = true
	if Input.is_action_just_released("ui_accept") and jetpacking:
		if rotation_point != Vector2.ZERO:
			stable = true
		jetpacking = false
	
	if jetpacking:
		if fuel <=0.0:
			jetpacking = false
		else:
			##fuel -= delta
			if stable:
				planet_movement.y -= 15
			else:
				jetpack_movement +=11*pointing_to
			if movement.y < -300:
				movement.y = -300
	
	var direction := Input.get_axis("left", "right")
	if rotation_point == Vector2.ZERO or not stable:
		planet_movement.x = 0
		vector_rotation += 0.1*direction
		rotation += 0.1*direction
	elif direction:
		planet_movement.x = direction * SPEED
	else:
		planet_movement.x = 0
	if rotation_point != Vector2.ZERO:
		#velocity = vector2planet * vertical
		velocity = planet_movement.x * vector2planet.rotated(deg_to_rad(-90)) + planet_movement.y * vector2planet
	else:
		velocity = Vector2.ZERO
	velocity += jetpack_movement
	move_and_slide()
	

func _change_fuel(new):
	if new < 0.0:
		fuel = 0.0
	elif new > 10.0:
		fuel = 10.0
	else:
		fuel = new
	fuel_label.text = str(snapped(fuel,0.01))+"s"

func _changed_rotating_around(new):
	rotating_around = new
	if new == null:
		rotation_point = Vector2.ZERO
		stable = false
		jetpack_movement = planet_movement.x * vector2planet.rotated(deg_to_rad(-90)) + planet_movement.y * vector2planet
		planet_pull = 0
		motion_mode = MOTION_MODE_FLOATING
	else:
		rotation_point=new.position
		vector2planet = (rotation_point - position).normalized()
		planet_movement = planet_movement.y * vector2planet
		prev_vector = movement.x * vector2planet.rotated(deg_to_rad(-90)) + movement.y * vector2planet
		planet_pull = 10
		if not jetpacking:
			stable = true
		motion_mode = MOTION_MODE_GROUNDED
