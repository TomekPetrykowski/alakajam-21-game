extends Area2D
class_name House



var hp = 5 : set = _hp_changed



func _hp_changed(new):
	get_parent().attacked = true
	if new<=0:
		Vars.houses_destroyed +=1
		queue_free()
	else:
		hp=new
