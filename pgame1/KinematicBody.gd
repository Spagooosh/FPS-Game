extends KinematicBody


var MOVE_SPEED = 8
var MOUSE_SENS = 0.3
var gravity = 2.3
var capncrunch = Vector3()
var jump_p = 2.5
var air_time = 0.0
var BONUS_GRAVITY = 1.0

var wall_normal
var direction
var wrunable = false
var grappling = false
var hookpoint = Vector3()
var hookpoint_get = false

var jump_num 
var g_num
var damage = 1
#var spread = 0.2
var mouse_sensitivity = 0.03

var velocity = Vector3()
var shots = 8
var current_weapon = 1
var shooting = false
var health = 100

onready var gaudio = $Head/MeshInstance/ghook/AudioStreamPlayer3D
onready var head = $Head
onready var ghook = $Head/MeshInstance/ghook

onready var rope = preload("res://rope.tscn")
onready var bhole = preload("res://bhole.tscn")
#onready var buckshot = preload("res://buckshot.tscn")

onready var gun1 = $Head/Gun1
onready var gun2 = $Head/hand3
onready var gun3 = $Head/Gun2

onready var sgun = $Head/hand3/shotgun/sgun
onready var sgun2 = $Head/hand3/shotgun/sgun2
onready var sgun3 = $Head/hand3/shotgun/sgun3
onready var sgun4 = $Head/hand3/shotgun/sgun4
onready var sgun5 = $Head/hand3/shotgun/sgun5
onready var sgun6 = $Head/hand3/shotgun/sgun6

onready var aimcast = $Head/aimcast
onready var muzzle = $Head/Gun1/Muzzle
onready var Muzzle = $Head/hand3/Muzzlesgun

onready var coll = $CollisionShape
onready var bonk = $Head/grapplecast/bonk
onready var timer = $Timer

onready var gcast = $Head/grapplecast
onready var anim_p = $Head/AnimationPlayer

onready var swardcast = $Head/swardcast
onready var audio_s = $Head/hand3/Spatial/Spatial/AudioStreamPlayer3D
onready var shotgun = $Head/shotgun
onready var audio_r = $AudioStreamPlayer3D
onready var t2 = $Timer2
onready var audio_2s = $Head/hand3/Spatial/Spatial/AudioStreamPlayer3D2
onready var bscast = $bscast


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
#	randomize()
#	for r in shotgun.get_children():
#			r.cast_to.x = rand_range(spread, -spread)
#			r.cast_to.y = rand_range(spread, -spread)
func _input(event):	 
	if event is InputEventMouseMotion:
		rotation_degrees.y -= MOUSE_SENS * event.relative.x
		$Head.rotation_degrees.x = clamp($Head.rotation_degrees.x - event.relative.y * MOUSE_SENS, -90, 90)


func grapple():

	if Input.is_action_just_pressed("grapple"):
		if gcast.is_colliding():
			if g_num == 0:
				if not grappling:
					grappling = true
					anim_p.play("grapple")
	if grappling:
		capncrunch.y = 0
		air_time = 0.0
		jump_num = 1
		g_num = 1
		MOUSE_SENS = 0
		var r = rope.instance()
		ghook.add_child(r)
		r.transform.origin = (ghook.global_transform.origin)
		r.shoot = true
		if not hookpoint_get:
			hookpoint = gcast.get_collision_point() + Vector3(0, 2.25, 0)
			hookpoint_get = true
			gaudio.play()
		if hookpoint.distance_to(transform.origin) > 1:
			if hookpoint_get:
				transform.origin = lerp(transform.origin, hookpoint, 0.01)
				
			yield(get_tree().create_timer(0.6), "timeout")
			grappling = false
			hookpoint_get = false
			MOUSE_SENS = 0.3
			
	if bonk.is_colliding():
		grappling = false
		hookpoint = null
		hookpoint_get = false
		global_translate(Vector3(0, -0.25, 0))
		
func wall_run():
	if wrunable:
		if Input.is_action_pressed("jump"):
			if Input.is_action_pressed("move_forwards"):
				if is_on_wall():
					jump_num = 1
					jump_p = 3
					wall_normal = get_slide_collision(0)
					yield(get_tree().create_timer(0.1), "timeout")
					capncrunch.y = 0
					air_time = 0.0
					direction = -wall_normal.normal * MOVE_SPEED
					MOVE_SPEED = 10
					g_num = 0
					if not is_on_wall():
						MOVE_SPEED = 8
						jump_p = 2.5

	
func _fire_shotgun():
	if Input.is_action_just_pressed("attack"):
		if shots >0:
			if not shooting:
				shooting = true
				if shooting:
						anim_p.play("shoot")
						audio_s.play()
						
#						for r in shotgun.get_children():
#							r.cast_to.x = rand_range(spread, -spread)
#							r.cast_to.y = rand_range(spread, -spread)
#							if r.is_colliding():
#
				var bullet = get_world().direct_space_state
				if sgun.is_colliding():
					if sgun.get_collider().is_in_group("Enemy"):
						print("hit enemy")
						sgun.get_collider().health -= damage 
										
#-------------------------------------------
#				var _collision2 = bullet.intersect_ray(Muzzle.global_transform.origin, sgun2.get_collision_point())
#				if collision:
#					var target = collision.collider
#					if target.is_in_group("Enemy"):
#						print("hit enemy")
#						target.health -= damage 
#
#				var _collision3 = bullet.intersect_ray(Muzzle.global_transform.origin, sgun3.get_collision_point())
#				if collision:
#					var target = collision.collider
#					if target.is_in_group("Enemy"):
#						print("hit enemy")
#						target.health -= damage
#
#				var _collision4 = bullet.intersect_ray(Muzzle.global_transform.origin, sgun4.get_collision_point())
#				if collision:
#					var target = collision.collider
#					if target.is_in_group("Enemy"):
#						print("hit enemy")
#						target.health -= damage 
#
#				var _collision5 = bullet.intersect_ray(Muzzle.global_transform.origin, sgun5.get_collision_point())
#				if collision:
#					var target = collision.collider
#					if target.is_in_group("Enemy"):
#						print("hit enemy")
#						target.health -= damage 
#
#				var _collision6 = bullet.intersect_ray(Muzzle.global_transform.origin, sgun6.get_collision_point())
#				if collision:
#					var target = collision.collider
#					if target.is_in_group("Enemy"):
#						print("hit enemy")
#						target.health -= damage 

#----------------------------------------

#				var bu = buckshot.instance()
#				sgun.add_child(bu)
#				bu.transform.origin = (bscast.global_transform.origin)
#				bu.shoot = true
#				shots -= 1
				yield(get_tree().create_timer(0.4), "timeout")
				audio_2s.play()
				yield(get_tree().create_timer(0.5), "timeout")
				shooting = false

func _process(_delta):
	if Input.is_action_pressed("exit"):
		get_tree().quit()
	if Input.is_action_pressed("restart"):
# warning-ignore:return_value_discarded
		get_tree().reload_current_scene()
	
		yield(get_tree().create_timer(0.31), "timeout")
#		saudio.play()
		var coll = swardcast.get_collider()
		if swardcast.is_colliding() and coll.has_method("kill"):
			coll.kill()
			
			
	weapon_select()
	
	
	if health <= 0:
		anim_p.play("death")
		
	
func shoot1():
	if Input.is_action_just_pressed("attack"):
		if aimcast.is_colliding():
# warning-ignore:shadowed_variable
			var bullet = get_world().direct_space_state
			var collision = bullet.intersect_ray(muzzle.global_transform.origin, aimcast.get_collision_point())
			if collision:
				var target = collision.collider
				if target.is_in_group("Enemy"):
					print("hit enemy")
					target.health -= damage
	
	
func weapon_select():
	if Input.is_action_just_pressed("weapon 1"):
		current_weapon = 1
	elif Input.is_action_just_pressed("weapon 2"):
		current_weapon = 2
	elif Input.is_action_just_pressed("weapon 3"):
		current_weapon = 3
	
	
	if current_weapon == 1:
		gun1.visible = true
		shoot1()
	else:
		gun1.visible = false

	if current_weapon == 3:
		gun3.visible = true
		gun3.shoot()
	else:
		gun3.visible = false

	if current_weapon == 2:
		gun2.visible = true
		_fire_shotgun()
	else:
		gun2.visible = false
		
	

func _physics_process(delta):
	
	var move_vec = Vector3()	
	if Input.is_action_pressed("move_forwards"):
		move_vec.z -= 1 
	if Input.is_action_pressed("move_backwards"):
		move_vec.z += 1 
	if Input.is_action_pressed("move_left"):
		move_vec.x -= 1 
	if Input.is_action_pressed("move_right"):
		move_vec.x += 1
	
	
	if Input.is_action_just_pressed("reload"):
		if shots == 0:
			anim_p.play("reloading")
			yield(get_tree().create_timer(0.5), "timeout")
			audio_r.play()
			yield(get_tree().create_timer(0.5), "timeout")
			audio_r.play()
			yield(get_tree().create_timer(0.5), "timeout")
			audio_r.play()
			yield(get_tree().create_timer(0.5), "timeout")
			audio_r.play()
			yield(get_tree().create_timer(0.5), "timeout")
			audio_r.play()
			yield(get_tree().create_timer(0.5), "timeout")
			audio_r.play()
			yield(get_tree().create_timer(0.5), "timeout")
			audio_r.play()
			yield(get_tree().create_timer(0.5), "timeout")
			audio_r.play()
			yield(get_tree().create_timer(0.12), "timeout")
			audio_2s.play()
			yield(get_tree().create_timer(0.2), "timeout")
			shots = 8


			
	move_vec = move_vec.normalized()
	move_vec = move_vec.rotated(Vector3(0, 1, 0), rotation.y)
# warning-ignore:return_value_discarded
	move_and_collide(move_vec * MOVE_SPEED * delta)

	grapple()
	wall_run()
	if is_on_floor():
		air_time = 0.0

	else:
			air_time += delta
			
	capncrunch.y -= (gravity * gravity * air_time * BONUS_GRAVITY) * delta

	if is_on_floor():
		
		jump_num = 0
		g_num = 0
		jump_p = 2.5
	if Input.is_action_pressed("jump") and is_on_floor():
		if jump_num == 0:
			capncrunch.y = jump_p
			jump_num = 1 
			wrunable = true
			timer.start()
	
	if Input.is_action_just_pressed("jump") and not is_on_floor():
		if jump_num == 1:
			jump_p = 2.7
			capncrunch.y = jump_p
			jump_num = 2
			air_time = 0.0
			wrunable = true
			timer.start()
# warning-ignore:return_value_discarded
	move_and_slide(capncrunch, Vector3.UP)
	
	
	if not is_on_floor():
		capncrunch.y -= gravity * delta

	else: 
		wrunable = false
		
# warning-ignore:return_value_discarded
	move_and_slide(capncrunch, Vector3.UP)

func kill():
	anim_p.play("death")
	
func _on_Timer_timeout():
	wrunable = false

#
#func _on_Timer2_timeout():
#	shootable = true
