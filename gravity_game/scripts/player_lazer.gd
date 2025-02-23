extends Area2D

var direction = Vector2(1,0) : set = _direction_changed
var SPEED = 300
var lifetime = 1.0


func _direction_changed(new):
	direction = new
	look_at(direction)


func _process(delta: float) -> void:
	position+=SPEED*direction*delta
	lifetime-= delta
	if lifetime<=0.0:
		queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body.name!="Player":
		queue_free()


func _on_area_entered(area: Area2D) -> void:
	if area is Enemy or area is House:
		area.hp-=1
		queue_free()
