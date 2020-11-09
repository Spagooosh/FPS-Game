extends Spatial

onready var muzzle = $Muzzle

onready var bullet = preload("res://Bullet.tscn")


func shoot():
	if Input.is_action_just_pressed("attack"):
		var b = bullet.instance()
		muzzle.add_child(b)
		b.transform.origin = (muzzle.global_transform.origin)
		b.shoot = true
