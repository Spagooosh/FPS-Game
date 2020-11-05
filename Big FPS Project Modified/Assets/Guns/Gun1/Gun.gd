extends Spatial

onready var muzzle = $Muzzle

onready var bullet = preload("res://Assets/Bullet.tscn")


func shoot():
	pass
#	if Input.is_action_pressed("shoot"):
#		if aimcast.is_colliding():
#			var bullet = get_world().direct_space_state
#			var collision = bullet.intersect_ray(muzzle.global_transform.origin, aimcast.get_collision_point())
#
#			if collision:
#				var target = collision.collider
#
#				if target.is_in_group("Enemy"):
#					print("hit enemy")
#					target.health -= damage
