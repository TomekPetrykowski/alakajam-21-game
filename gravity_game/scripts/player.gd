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
	pointing_to = Vector2(-1,0).rotated($Sprite2D.rotation)
	if rotation_point != Vector2.ZERO:
		up_direction = vector2planet*-1
		vector_rotation = position.angle_to_point(rotation_point)
		vector2planet = (rotation_point - position).normalized()
		
		if stable:
			planet_movement.y += 10
			$Sprite2D.rotation = vector_rotation
		else:
			
			jetpack_movement += 10 * vector2planet
	jetpack_movement*=0.99
	
	if is_on_floor():
		stable = true
		jetpack_movement = Vector2.ZERO
		self.fuel += delta*2
		planet_movement.y = 0
		$AnimationPlayer.play("idle")
	else:
		if jetpacking:
			$AnimationPlayer.play("jetpacking")
		else:
			$AnimationPlayer.play("jump")
	if Input.is_action_just_pressed("ui_accept"):
		if is_on_floor():
			planet_movement.y = JUMP_VELOCITY
		elif fuel >= 0.0:
			jetpacking = true
	if Input.is_action_just_released("ui_accept") and jetpacking:
		if rotation_point != Vector2.ZERO:
			stable = true
		else:
			$AnimationPlayer.play("floating")
		jetpacking = false
	
	if jetpacking:
		$AnimationPlayer.play("flying")
		if fuel <=0.0:
			jetpacking = false
			
		else:
			##fuel -= delta
			if stable:
				planet_movement.y -= 15
				#if movement.y > -500:
					#movement.y = -500
			else:
				jetpack_movement +=15*pointing_to
				#jetpack_movement
				#if jetpack_movement.length()>=500:
					
			
	
	var direction := Input.get_axis("left", "right")
	if rotation_point == Vector2.ZERO or not stable:
		planet_movement.x = 0
		vector_rotation += 0.1*direction
		$Sprite2D.rotation += 0.1*direction
	elif direction:
		if direction <0:
			$Sprite2D.flip_v = true
		else:
			$Sprite2D.flip_v = false
		if is_on_floor():
			$AnimationPlayer.play("walking")
		planet_movement.x = direction * SPEED
	else:
		$AnimationPlayer.play("idle")
		planet_movement.x = 0
	if rotation_point != Vector2.ZERO:
		#velocity = vector2planet * vertical
		velocity = planet_movement.x * vector2planet.rotated(deg_to_rad(-90)) + planet_movement.y * vector2planet
	else:
		velocity = Vector2.ZERO
	velocity += jetpack_movement
	move_and_slide()
	
	#print(rad_to_deg($Sprite2D.rotation))
	#print(rad_to_deg(get_local_mouse_position().angle()))
	#print(rad_to_deg($Sprite2D.rotation-get_local_mouse_position().angle()))
	#if get_local_mouse_position().rotated($Sprite2D.rotation).x<0:
		#$Sprite2D.flip_v = false
		#$Weapon.flip_v = false
	#else:
		#$Sprite2D.flip_v = true
		#$Weapon.flip_v = true
	$Weapon.rotation=get_angle_to(get_global_mouse_position())
	$Weapon.position = (get_local_mouse_position().normalized())*6*4
	#print(velocity,planet_movement,jetpack_movement)
	

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
		jetpack_movement += planet_movement.x * vector2planet.rotated(deg_to_rad(-90)) + planet_movement.y * vector2planet
		planet_movement = Vector2.ZERO
		planet_pull = 0
		motion_mode = MOTION_MODE_FLOATING
		$AnimationPlayer.play("floating")
	else:
		rotation_point=new.position
		vector2planet = (rotation_point - position).normalized()
		planet_movement = planet_movement.y * vector2planet
		prev_vector = movement.x * vector2planet.rotated(deg_to_rad(-90)) + movement.y * vector2planet
		planet_pull = 10
		if not jetpacking:
			stable = true
			$AnimationPlayer.play("idle")
		motion_mode = MOTION_MODE_GROUNDED
