extends KinematicBody


var health = 200
var target
var speed = 6
var gravity = 3
var air_time = 0.0
const BONUS_GRAVITY = 3.0
var velocity = Vector3()

var space_state


onready var collided = $CollisionShape

func _ready():
	space_state = get_world().direct_space_state


func _process(_delta):
	if health <= 0:
		queue_free()
	if target:
		var result = space_state.intersect_ray(global_transform.origin, target.global_transform.origin)
		if result.collider.is_in_group("Player"):
			look_at(target.global_transform.origin, Vector3.UP)
			move_to_target()
		else:
			pass
		
#	var collision = move_and_collide(Vector3())
#	if collision:
#		if collision.collider.is_in_group("Player"):
#			print("dmg player")
	
func _physics_process(delta):
	velocity.y -= (gravity + gravity * air_time * BONUS_GRAVITY) * delta
	move_and_slide(velocity, Vector3.UP)

func _on_Area_body_entered(body):
	if body.is_in_group("Player"):
		target = body
	print(body.name + " entered")


func _on_Area_body_exited(body):
	if body.is_in_group("Player"):
		target = null
	print(body.name + " exited")


func _on_ContactDetection_body_entered(body):
	if body.is_in_group("Player"):
		body.health -= 20
		print("Hit Player")
		
		
func move_to_target():
	var direction = (target.transform.origin - transform.origin).normalized()
	move_and_slide(direction * speed, Vector3.UP)
