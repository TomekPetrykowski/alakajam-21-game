extends CharacterBody2D


#@onready var planet = $"../StaticBody2D"

const SPEED = 300.0
const JUMP_VELOCITY = -300.0

var vector2planet = Vector2.ZERO
var gravity = Vector2.ZERO
var jump_power = 0
var vertical = 0
var horizontal = 0

var rotation_point = Vector2.ZERO

func _physics_process(_delta: float) -> void:
	# Add the gravity.
	
	#velocity = gravity
	#velocity = Vector2.ZERO
	#if not is_on_floor():
		#velocity += get_gravity() * delta
	#position = get_global_mouse_position()
	look_at(rotation_point)
	#print(rotation)
	
	vector2planet = (rotation_point - position).normalized()
	#print(vector2planet.normalized())
	vertical += 10
	up_direction = vector2planet*-1
	
	
	#if is_on_floor():
		#gravity = Vector2.ZERO
		#print("yay")
	#else:
		#print("nay")
		#gravity += 5 * vector2planet
	#velocity = gravity
	#if is_on_ceiling():
		#print("aya")
	#if is_on_wall():
		#print("aaa")
	#rotation = rad_to_deg(get_angle_to(planet.position))s
	#print(rad_to_deg(get_angle_to(planet.position)))
#
	## Handle jump.
	if Input.is_action_just_pressed("ui_accept"):
		#velocity = JUMP_VELOCITY * vector2planet
		vertical = JUMP_VELOCITY
	
	#velocity = vertical * vector2planet
#
	## Get the input direction and handle the movement/deceleration.
	## As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		#velocity = direction * SPEED * vector2planet.rotated(deg_to_rad(90))
		horizontal = direction * SPEED
	else:
		horizontal = 0
		#velocity.x = move_toward(velocity.x, 0, SPEED)
		
	velocity = horizontal * vector2planet.rotated(deg_to_rad(90)) + vertical * vector2planet
	move_and_slide()
	
