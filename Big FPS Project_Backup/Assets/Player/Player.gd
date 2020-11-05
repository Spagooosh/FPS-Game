extends KinematicBody


var speed = 10
var gravity = 3
var jump_power = 8
var air_time = 0.0
const BONUS_GRAVITY = 3.0
var velocity = Vector3()
var health = 200

var current_weapon = 1


onready var head = $Head
onready var camera = $Head/Camera
onready var aimcast = $Head/Camera/RayCast
onready var gun1 = $Head/Hand/Gun
onready var gun2 = $Head/Hand/Gun2
onready var muzzle = $Head/Hand/Gun2/Muzzle



onready var b_decal = preload("res://Assets/BulletHole.tscn")
onready var bullet = preload("res://Assets/Bullet.tscn")

var damage = 20

var mouse_sensitivity = 0.3

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _input(event):
	if event is InputEventMouseMotion:
		$Head.rotation_degrees.x = clamp($Head.rotation_degrees.x - event.relative.y * mouse_sensitivity, -90, 90)
		rotation_degrees.y -= event.relative.x * mouse_sensitivity
	
	
	if event is InputEventMouseButton:
		if event.is_pressed():
# warning-ignore:return_value_discarded
			clamp(current_weapon, 1, 2)
			if event.button_index == BUTTON_WHEEL_UP:
				if current_weapon < 2:
					current_weapon += 1
			elif event.button_index == BUTTON_WHEEL_DOWN:
				if current_weapon > 1:
					current_weapon -= 1
	
	
	
func weapon_select():
	if Input.is_action_just_pressed("weapon1"):
		current_weapon = 1
	elif Input.is_action_just_pressed("weapon2"):
		current_weapon = 2
	
	
	if current_weapon == 1:
		gun1.visible = true
		if Input.is_action_just_pressed("shoot"):
			if aimcast.is_colliding():
# warning-ignore:shadowed_variable
				var bullet = get_world().direct_space_state
				var collision = bullet.intersect_ray(muzzle.global_transform.origin, aimcast.get_collision_point())

				if collision:
					var target = collision.collider

					if target.is_in_group("Enemy"):
						print("hit enemy")
						target.health -= damage
	else:
		gun1.visible = false
		
	if current_weapon == 2:
		gun2.visible = true
		gun2.shoot()
	else:
		gun2.visible = false

func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		

func _physics_process(delta):
	
	weapon_select()
	
	if health <= 0:
		queue_free()
	
	var move_vec = Vector3()
	
	
#     ~~~~~~ Projectile Weapon ~~~~~~~
	
#	if Input.is_action_just_pressed("shoot"):
#		var b = bullet.instance()
#		if aimcast.is_colliding():
#			muzzle.add_child(b)
#			b.transform.origin = (muzzle.global_transform.origin)
#			b.shoot = true
#

# ~~~~~~~ Hitscan Weapon ~~~~~~~~~
	
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

# ~~~~~~~ Bullet Holes WIP ~~~~~~~

#			var bullet_d = b_decal.instance()
#			if aimcast.is_colliding():
#				aimcast.get_collider().add_child(bullet_d)
#				bullet_d.global_transform.origin = aimcast.get_collision_point()
#				bullet_d.look_at(aimcast.get_collision_point() + aimcast.get_collision_normal(), Vector3.UP)
	
	
	if Input.is_action_pressed("move_forward"):
		move_vec.z -= 1
	if Input.is_action_pressed("move_backward"):
		move_vec.z += 1
	if Input.is_action_pressed("move_left"):
		move_vec.x -= 1
	if Input.is_action_pressed("move_right"):
		move_vec.x += 1
	move_vec = move_vec.rotated(Vector3(0, 1, 0), rotation.y)
# warning-ignore:return_value_discarded
	move_and_collide(move_vec * speed * delta)
	
	if is_on_floor():
		air_time = 0.0
	else:
		air_time += delta

	velocity.y -= (gravity + gravity * air_time * BONUS_GRAVITY) * delta
	
	if Input.is_action_pressed("jump") and is_on_floor(): 
		velocity.y = jump_power
		
# warning-ignore:return_value_discarded
	move_and_slide(velocity, Vector3.UP)
